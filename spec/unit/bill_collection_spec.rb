require 'spec_helper'

describe "SpsBill::BillCollection" do

  describe "##load" do
    let(:path_spec) { '*.pdf' }
    let(:mock_collection) { ['a.pdf','b.pdf'] }
    before do
      Dir.stub(:[]).and_return(mock_collection)
      SpsBill::Bill.any_instance.stub(:do_complete_parse).and_return(nil)
    end
    let(:bills) { SpsBill::BillCollection.load(path_spec) }
    subject { bills }
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
    subject { bills.total_amounts }
    let(:expected) { [['2012-02-01',111.12],['2012-03-01',222.23]] }
    it { should eql(expected)}
  end

  describe "#electricity_usages" do
    let(:bill_a) { SpsBill::Bill.new(nil) }
    let(:bill_b) { SpsBill::Bill.new(nil) }
    let(:bills) { SpsBill::BillCollection.new }
    before do
      bill_a.instance_variable_set(:@invoice_month, Date.parse('2012-02-01'))
      bill_a.instance_variable_set(:@electricity_usage, [{ kwh: 12.0, rate: 0.1234, amount: 12.34 }] )
      bill_b.instance_variable_set(:@invoice_month, Date.parse('2012-03-01'))
      bill_b.instance_variable_set(:@electricity_usage, [{ kwh: 24.0, rate: 0.5678, amount: 56.78 }])
      bills << bill_a
      bills << bill_b
    end
    subject { bills.electricity_usages }
    let(:expected) { [['2012-02-01', 12.0, 0.1234, 12.34],['2012-03-01', 24.0, 0.5678, 56.78]] }
    it { should eql(expected)}
  end


  describe "#gas_usages" do
    let(:bill_a) { SpsBill::Bill.new(nil) }
    let(:bill_b) { SpsBill::Bill.new(nil) }
    let(:bills) { SpsBill::BillCollection.new }
    before do
      bill_a.instance_variable_set(:@invoice_month, Date.parse('2012-02-01'))
      bill_a.instance_variable_set(:@gas_usage, [{ kwh: 12.0, rate: 0.1234, amount: 12.34 }] )
      bill_b.instance_variable_set(:@invoice_month, Date.parse('2012-03-01'))
      bill_b.instance_variable_set(:@gas_usage, [{ kwh: 24.0, rate: 0.5678, amount: 56.78 }])
      bills << bill_a
      bills << bill_b
    end
    subject { bills.gas_usages }
    let(:expected) { [['2012-02-01', 12.0, 0.1234, 12.34],['2012-03-01', 24.0, 0.5678, 56.78]] }
    it { should eql(expected)}
  end

  describe "#water_usages" do
    let(:bill_a) { SpsBill::Bill.new(nil) }
    let(:bill_b) { SpsBill::Bill.new(nil) }
    let(:bills) { SpsBill::BillCollection.new }
    before do
      bill_a.instance_variable_set(:@invoice_month, Date.parse('2012-02-01'))
      bill_a.instance_variable_set(:@water_usage, [{ cubic_m: 12.0, rate: 0.1234, amount: 12.34 }] )
      bill_b.instance_variable_set(:@invoice_month, Date.parse('2012-03-01'))
      bill_b.instance_variable_set(:@water_usage, [{ cubic_m: 24.0, rate: 0.5678, amount: 56.78 }])
      bills << bill_a
      bills << bill_b
    end
    subject { bills.water_usages }
    let(:expected) { [['2012-02-01', 12.0, 0.1234, 12.34],['2012-03-01', 24.0, 0.5678, 56.78]] }
    it { should eql(expected)}
  end

end