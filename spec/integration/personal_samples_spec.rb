require 'spec_helper'
include PdfSamplesHelper

describe "Personal PDF Samples" do

  if personal_pdf_sample_names.empty?
    pending %(

    You can place the PDFs of your own bills in spec/fixtures/personal_pdf_samples.
    They will be tested when you run the specs, but are hidden from being added to the
    git repository.

    )
  end

  # This will scan all *.pdf files in spec/fixtures/personal_pdf_samples
  # and do basic verification of the file structure without any effort from you.
  personal_pdf_sample_names.each do |sample|
    describe sample do
      let(:sample_name) { sample }
      let(:bill) { SpsBill::Bill.new(sample_name) }

      it_behaves_like "has a valid reader", :bill
      it_behaves_like "has a valid account number", :bill
      it_behaves_like "has a valid invoice date", :bill


    end
  end

  # This will read spec/fixtures/personal_pdf_samples/expectations.yml
  # and and test according to the definitions it contains.
  #
  # expectations.yml should contain a YAML structure like this:
  #
  # ---
  # file1.pdf:
  #   :account_number: '8123123123'
  #   :invoice_date: 2011-05-31
  #   :invoice_month: 2011-05-01
  #   :total_amount: 251.44
  #   :electricity_usage:
  #   - :kwh: 4.0
  #     :rate: 0.241
  #     :amount: 0.97
  #   - :kwh: 616.0
  #     :rate: 0.2558
  #     :amount: 157.57
  #   :gas_usage:
  #   - :kwh: 18.0
  #     :rate: 0.1799
  #     :amount: 3.24
  #   :water_usage:
  #   - :cubic_m: 36.1
  #     :rate: 1.17
  #     :amount: 42.24
  #   - :cubic_m: -3.0
  #     :rate: 1.4
  #     :amount: -4.2
  # file2.pdf:
  #   :account_number: '8123123123'
  #   ... (etc)
  #
  personal_pdf_sample_expectations.each do |sample_name,expectations|
    describe sample_name do
      let(:sample_file) { personal_pdf_sample_path.join(sample_name).to_s }
      let(:bill) { SpsBill::Bill.new(sample_file) }
      subject { bill }

      its(:account_number) { should eql(expectations[:account_number])}
      its(:total_amount) { should eql(expectations[:total_amount])}
      its(:invoice_date) { should eql(expectations[:invoice_date])}
      its(:invoice_month) { should eql(expectations[:invoice_month])}

      if expectations[:electricity_usage]
        its(:electricity_usage) { should eql(expectations[:electricity_usage])}
      end

      if expectations[:gas_usage]
        its(:gas_usage) { should eql(expectations[:gas_usage])}
      end

      if expectations[:water_usage]
        its(:water_usage) { should eql(expectations[:water_usage])}
      end

    end
  end

end
