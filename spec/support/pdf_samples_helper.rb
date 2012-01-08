module PdfSamplesHelper

  def pdf_sample_names
    Dir["#{File.dirname(__FILE__)}/../fixtures/pdf_samples/*.pdf"]
  end

  def first_pdf_sample_name
    pdf_sample_names.first
  end

  def personal_pdf_sample_names
    Dir["#{File.dirname(__FILE__)}/../fixtures/personal_pdf_samples/*.pdf"]
  end

end