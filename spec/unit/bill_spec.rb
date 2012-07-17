require 'spec_helper'

describe "SpsBill::Bill" do
  let(:bill) { SpsBill::Bill.new(nil) }
  subject { bill }

  describe "##new" do
    it { should be_a(SpsBill::Bill) }
  end

  [
    :account_number,
    :total_amount,
    :invoice_date,
    :invoice_month,
    :electricity_usage
  ].each do |supported_attribute|
    describe "##{supported_attribute}" do
      it { should respond_to(supported_attribute) }
    end
  end

end
