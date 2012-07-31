require 'spec_helper'
require 'getoptions'

describe SpsBill::Shell do

  describe "##usage" do
    subject { SpsBill::Shell.usage }
    it "should print help" do
      STDOUT.should_receive(:puts) if RUBY_ENGINE.to_s != 'jruby' # cannot get this to work with JRuby yet
      subject
    end
  end

  describe "with help parameter" do
    let(:options) { GetOptions.new(SpsBill::Shell::OPTIONS, ['-h']) }
    let(:shell) { SpsBill::Shell.new(options) }
    subject { shell.options[:help] }
    it { should be_true }
    describe "#run" do
      subject { shell.run }
      it "should print usage" do
        SpsBill::Shell.should_receive(:usage)
        subject
      end
    end
  end

  describe "with raw parameter" do
    let(:options) { GetOptions.new(SpsBill::Shell::OPTIONS, ['-r']) }
    let(:shell) { SpsBill::Shell.new(options) }
    subject { shell.options[:raw] }
    it { should be_true }
    describe "#format_header" do
      let(:data) { ['some','data'] }
      subject { shell.format_header(data) }
      it { should be_nil }
    end
  end

  {
    'all' => :all_data,
    'charges' => :total_amounts,
    'electricity' => :electricity_usages,
    'gas' => :gas_usages,
    'water' => :water_usages
  }.each do |data,expected_method|
    describe "with data=#{data} parameter" do
      let(:options) { GetOptions.new(SpsBill::Shell::OPTIONS, ['-d',data]) }
      let(:shell) { SpsBill::Shell.new(options) }
      subject { shell.options[:data] }
      it { should eql(data) }
      describe "#run" do
        subject { shell.run }
        it "should export #{expected_method}" do
          shell.should_receive(:export).with(expected_method)
          subject
        end
      end
    end
  end

end