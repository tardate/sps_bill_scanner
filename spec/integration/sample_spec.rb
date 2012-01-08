require 'spec_helper'
include PdfSamplesHelper

describe "PDF Sample" do
  let(:sample_name) { first_pdf_sample_name }
  let(:bill) { SpsBill::Bill.new(sample_name) }

  describe "#load_source_with_quirks [private]" do
    let(:stream) { bill.send(:load_source_with_quirks) }
    subject { stream.read(4) }
    it { should eql("%PDF") }
  end

  it_behaves_like "has a valid reader", :bill
  it_behaves_like "has a valid account number", :bill
  it_behaves_like "has a valid invoice month", :bill

end
