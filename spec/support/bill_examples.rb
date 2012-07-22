shared_examples_for "has a valid reader" do |resource_key|
  # args:
  # +resource_key+ is the sym for the resource to test
  describe "#reader" do
    let(:resource) { eval "#{resource_key}" }
    let(:reader) { resource.reader }
    subject { reader }
    it { should be_a(PDF::Reader::Turtletext) }
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

shared_examples_for "has a valid invoice date" do |resource_key|
  # args:
  # +resource_key+ is the sym for the resource to test
  describe "#invoice_date" do
    let(:resource) { eval "#{resource_key}" }
    subject { resource.invoice_date  }
    it { should be_a(Date) }
  end
end