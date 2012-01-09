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

  personal_pdf_sample_names.each do |sample|
    describe sample do
      let(:sample_name) { sample }
      let(:bill) { SpsBill::Bill.new(sample_name) }

      it_behaves_like "has a valid reader", :bill
      it_behaves_like "has a valid account number", :bill
      it_behaves_like "has a valid invoice month", :bill
    end
  end

end
