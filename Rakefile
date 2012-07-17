# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'rspec'
require 'rspec/core/rake_task'

$LOAD_PATH.unshift('lib')
require 'sps_bill/version'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "sps_bill"
  gem.version = SpsBill::Version::STRING
  gem.homepage = "https://github.com/tardate/sps_bill"
  gem.license = "MIT"
  gem.summary = %Q{SP Services PDF bill structured data reader}
  gem.description = %Q{a library that can read SP Services PDF bills and extract and summarize the bill details}
  gem.email = "gallagher.paul@gmail.com"
  gem.authors = ["Paul Gallagher"]
  gem.files.exclude 'pkg/*'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

desc "Run all RSpec test examples"
RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = ["-c", "-f progress"]
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sps_bill #{SpsBill::Version::STRING}"
  rdoc.rdoc_files.include('README*', 'lib/**/*.rb')
end
