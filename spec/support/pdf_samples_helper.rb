require 'pathname'
require 'yaml'

module PdfSamplesHelper

  def pdf_sample_path
    Pathname.new(File.dirname(__FILE__)).join('..','fixtures','pdf_samples')
  end

  def personal_pdf_sample_path
    Pathname.new(File.dirname(__FILE__)).join('..','fixtures','personal_pdf_samples')
  end

  def pdf_sample_name
    pdf_sample_path.join('bill_a.pdf').to_s
  end

  def junk_prefix_pdf_sample_name
    pdf_sample_path.join('junk_prefix.pdf').to_s
  end

  def personal_pdf_sample_names
    Dir["#{File.dirname(__FILE__)}/../fixtures/personal_pdf_samples/*.pdf"]
  end

  def personal_pdf_sample_expectations_path
    Pathname.new(File.dirname(__FILE__)).join('..','fixtures','personal_pdf_samples','expectations.yml')
  end

  def personal_pdf_sample_expectations
    begin
      YAML.load_file personal_pdf_sample_expectations_path
    rescue
      []
    end
  end
end