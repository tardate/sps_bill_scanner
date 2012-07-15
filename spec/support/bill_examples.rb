shared_examples_for "has a valid reader" do |resource_key|
  # args:
  # +resource_key+ is the sym for the resource to test
  describe "#reader" do
    let(:resource) { eval "#{resource_key}" }
    let(:reader) { resource.reader }
    subject { reader }
    it { should be_a(PDF::StructuredReader) }
  end
end

shared_examples_for "has a valid account number" do |resource_key|
  # args:
  # +resource_key+ is the sym for the resource to test
  describe "#account_number" do
    let(:resource) { eval "#{resource_key}" }
    subject { resource.account_number  }
    it { should be_a(String) }
    it { should match(/^\d+$/) }
  end
end

shared_examples_for "has a valid invoice month" do |resource_key|
  # args:
  # +resource_key+ is the sym for the resource to test
  describe "#invoice_month" do
    let(:resource) { eval "#{resource_key}" }
    subject { resource.invoice_month  }
    it { should be_a(Date) }
  end
end