require 'spec_helper'
include PdfSamplesHelper

describe "Personal PDF Samples" do

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
