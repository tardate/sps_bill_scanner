require 'spec_helper'
include PdfSamplesHelper

describe "PDF Sample" do
  let(:sample_name) { pdf_sample_name }
  let(:bill) { SpsBill::Bill.new(sample_name) }

  it_behaves_like "has a valid reader", :bill
  it_behaves_like "has a valid account number", :bill
  it_behaves_like "has a valid invoice month", :bill

end
