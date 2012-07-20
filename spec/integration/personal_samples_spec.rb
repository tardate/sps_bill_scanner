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
  # See spec/fixtures/personal_pdf_samples/expectations.yml.sample
  # for details on how to setup the expectations.yml file
  #
  personal_pdf_sample_expectations.each do |sample_name,expectations|
    describe sample_name do
      let(:sample_file) { personal_pdf_sample_path.join(sample_name).to_s }
      let(:bill) { SpsBill::Bill.new(sample_file) }
      subject { bill }

      if expectations[:account_number]
        its(:account_number) { should eql(expectations[:account_number])}
      end

      if expectations[:total_amount]
        its(:total_amount) { should eql(expectations[:total_amount])}
      end

      if expectations[:invoice_date]
        its(:invoice_date) { should eql(expectations[:invoice_date])}
      end

      if expectations[:invoice_month]
        its(:invoice_month) { should eql(expectations[:invoice_month])}
      end

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
