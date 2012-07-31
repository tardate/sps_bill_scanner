require 'spec_helper'

describe SpsBill::BillCollection do

  describe "##load" do
    let(:bills) { SpsBill::BillCollection.load(path_spec) }
    subject { bills }

    context "when path spec provided" do
      let(:path_spec) { '*.pdf' }
      let(:mock_collection) { ['a.pdf','b.pdf'] }
      before do
        Dir.stub(:[]).and_return(mock_collection)
        SpsBill::Bill.any_instance.stub(:do_complete_parse).and_return(nil)
      end
      it { should be_a(SpsBill::BillCollection) }
      its(:size) { should eql(2) }

      describe "#first" do
        subject { bills.first }
        it { should be_a(SpsBill::Bill) }
        its(:source_file) { should eql('a.pdf') }
      end
      describe "#last" do
        subject { bills.last }
        it { should be_a(SpsBill::Bill) }
        its(:source_file) { should eql('b.pdf') }
      end
    end

    context "when file array provided" do
      let(:path_spec) { ['a.pdf','b.pdf'] }
      before do
        SpsBill::Bill.any_instance.stub(:do_complete_parse).and_return(nil)
      end
      it { should be_a(SpsBill::BillCollection) }
      its(:size) { should eql(2) }

      describe "#first" do
        subject { bills.first }
        it { should be_a(SpsBill::Bill) }
        its(:source_file) { should eql('a.pdf') }
      end
      describe "#last" do
        subject { bills.last }
        it { should be_a(SpsBill::Bill) }
        its(:source_file) { should eql('b.pdf') }
      end
    end
  end

  describe "#headers" do
    {
      :total_amounts => ['invoice_month','amount'],
      :electricity_usages => ['invoice_month','kwh','rate','amount'],
      :gas_usages => ['invoice_month','kwh','rate','amount'],
      :water_usages => ['invoice_month','cubic_m','rate','amount'],
      :all_data => ['invoice_month','measure','kwh','cubic_m','rate','amount'],
      :unknown => nil
    }.each do |dataset_selector,expected|
      context "with #{dataset_selector} selector" do
        subject { SpsBill::BillCollection.new.headers(dataset_selector) }
        it { should eql(expected) }
      end
    end
  end

  describe "#total_amounts" do
    let(:bill_a) { SpsBill::Bill.new(nil) }
    let(:bill_b) { SpsBill::Bill.new(nil) }
    let(:bills) { SpsBill::BillCollection.new }
    before do
      bill_a.instance_variable_set(:@invoice_month, Date.parse('2012-02-01'))
      bill_a.instance_variable_set(:@total_amount, 111.12)
      bill_b.instance_variable_set(:@invoice_month, Date.parse('2012-03-01'))
      bill_b.instance_variable_set(:@total_amount, 222.23)
      bills << bill_a
      bills << bill_b
    end
    subject { bills.total_amounts(style) }
    context "with solo style" do
      let(:style) { :solo }
      let(:expected) { [['2012-02-01',111.12],['2012-03-01',222.23]] }
      it { should eql(expected)}
    end
    context "with all style" do
      let(:style) { :all }
      let(:expected) { [['2012-02-01','total_charges',nil,nil,nil,111.12],['2012-03-01','total_charges',nil,nil,nil,222.23]] }
      it { should eql(expected)}
    end
  end

  describe "#electricity_usages" do
    let(:bill_a) { SpsBill::Bill.new(nil) }
    let(:bill_b) { SpsBill::Bill.new(nil) }
    let(:bills) { SpsBill::BillCollection.new }
    before do
      bill_a.instance_variable_set(:@invoice_month, Date.parse('2012-02-01'))
      bill_a.instance_variable_set(:@electricity_usage, [{ :kwh => 12.0, :rate => 0.1234, :amount => 12.34 }] )
      bill_b.instance_variable_set(:@invoice_month, Date.parse('2012-03-01'))
      bill_b.instance_variable_set(:@electricity_usage, [{ :kwh => 24.0, :rate => 0.5678, :amount => 56.78 }])
      bills << bill_a
      bills << bill_b
    end
    subject { bills.electricity_usages(style) }
    context "with solo style" do
      let(:style) { :solo }
      let(:expected) { [['2012-02-01', 12.0, 0.1234, 12.34],['2012-03-01', 24.0, 0.5678, 56.78]] }
      it { should eql(expected)}
    end
    context "with all style" do
      let(:style) { :all }
      let(:expected) { [['2012-02-01', 'electricity', 12.0, nil, 0.1234, 12.34],['2012-03-01', 'electricity', 24.0, nil, 0.5678, 56.78]] }
      it { should eql(expected)}
    end
  end


  describe "#gas_usages" do
    let(:bill_a) { SpsBill::Bill.new(nil) }
    let(:bill_b) { SpsBill::Bill.new(nil) }
    let(:bills) { SpsBill::BillCollection.new }
    before do
      bill_a.instance_variable_set(:@invoice_month, Date.parse('2012-02-01'))
      bill_a.instance_variable_set(:@gas_usage, [{ :kwh => 12.0, :rate => 0.1234, :amount => 12.34 }] )
      bill_b.instance_variable_set(:@invoice_month, Date.parse('2012-03-01'))
      bill_b.instance_variable_set(:@gas_usage, [{ :kwh => 24.0, :rate => 0.5678, :amount => 56.78 }])
      bills << bill_a
      bills << bill_b
    end
    subject { bills.gas_usages(style) }
    context "with solo style" do
      let(:style) { :solo }
      let(:expected) { [['2012-02-01', 12.0, 0.1234, 12.34],['2012-03-01', 24.0, 0.5678, 56.78]] }
      it { should eql(expected)}
    end
    context "with all style" do
      let(:style) { :all }
      let(:expected) { [['2012-02-01', 'gas', 12.0, nil, 0.1234, 12.34],['2012-03-01', 'gas', 24.0, nil, 0.5678, 56.78]] }
      it { should eql(expected)}
    end
  end

  describe "#water_usages" do
    let(:bill_a) { SpsBill::Bill.new(nil) }
    let(:bill_b) { SpsBill::Bill.new(nil) }
    let(:bills) { SpsBill::BillCollection.new }
    before do
      bill_a.instance_variable_set(:@invoice_month, Date.parse('2012-02-01'))
      bill_a.instance_variable_set(:@water_usage, [{ :cubic_m => 12.0, :rate => 0.1234, :amount => 12.34 }] )
      bill_b.instance_variable_set(:@invoice_month, Date.parse('2012-03-01'))
      bill_b.instance_variable_set(:@water_usage, [{ :cubic_m => 24.0, :rate => 0.5678, :amount => 56.78 }])
      bills << bill_a
      bills << bill_b
    end
    subject { bills.water_usages(style) }
    context "with solo style" do
      let(:style) { :solo }
      let(:expected) { [['2012-02-01', 12.0, 0.1234, 12.34],['2012-03-01', 24.0, 0.5678, 56.78]] }
      it { should eql(expected)}
    end
    context "with all style" do
      let(:style) { :all }
      let(:expected) { [['2012-02-01', 'water', nil, 12.0, 0.1234, 12.34],['2012-03-01', 'water', nil, 24.0, 0.5678, 56.78]] }
      it { should eql(expected)}
    end
  end

end