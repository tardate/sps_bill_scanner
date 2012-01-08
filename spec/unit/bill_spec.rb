require 'spec_helper'

describe "SpsBill::Bill" do
  describe "##new" do
    subject { SpsBill::Bill.new(nil) }
    it { should be_a(SpsBill::Bill) }
  end
end
