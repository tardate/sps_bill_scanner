# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sps_bill"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Gallagher"]
  s.date = "2012-08-01"
  s.description = "a library that can read SP Services PDF bills and extract and summarize the bill details"
  s.email = "gallagher.paul@gmail.com"
  s.executables = ["sps_bill"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".rvmrc",
    ".travis.yml",
    "CHANGELOG",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "bin/sps_bill",
    "lib/sps_bill.rb",
    "lib/sps_bill/bill.rb",
    "lib/sps_bill/bill_collection.rb",
    "lib/sps_bill/bill_parser.rb",
    "lib/sps_bill/shell.rb",
    "lib/sps_bill/version.rb",
    "scripts/data/.gitkeep",
    "scripts/data/all_services.csv.sample",
    "scripts/data/all_services.sample.pdf",
    "scripts/data/elec_and_water_only.csv.sample",
    "scripts/data/elec_and_water_only.sample.pdf",
    "scripts/full_analysis.R",
    "scripts/scan_all_bills.sh",
    "spec/fixtures/pdf_samples/.gitkeep",
    "spec/fixtures/personal_pdf_samples/.gitkeep",
    "spec/fixtures/personal_pdf_samples/expectations.yml.sample",
    "spec/integration/personal_samples_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/bill_examples.rb",
    "spec/support/pdf_samples_helper.rb",
    "spec/unit/bill_collection_spec.rb",
    "spec/unit/bill_spec.rb",
    "spec/unit/shell_spec.rb",
    "sps_bill.gemspec"
  ]
  s.homepage = "https://github.com/tardate/sps_bill_scanner"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "SP Services PDF bill structured data reader"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pdf-reader-turtletext>, ["~> 0.2.2"])
      s.add_runtime_dependency(%q<getoptions>, ["~> 0.3"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1.4"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rake>, "~> 12.3.3")
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.11"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
    else
      s.add_dependency(%q<pdf-reader-turtletext>, ["~> 0.2.2"])
      s.add_dependency(%q<getoptions>, ["~> 0.3"])
      s.add_dependency(%q<bundler>, ["~> 1.1.4"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rake>, "~> 12.3.3")
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.11"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<pdf-reader-turtletext>, ["~> 0.2.2"])
    s.add_dependency(%q<getoptions>, ["~> 0.3"])
    s.add_dependency(%q<bundler>, ["~> 1.1.4"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rake>, "~> 12.3.3")
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.11"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
  end
end

