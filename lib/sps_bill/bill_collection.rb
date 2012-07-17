# Bill collection class for speacial handling of an array of SP Services PDF bills
#
class SpsBill::BillCollection < Array

  class << self

    # Returns an array of Bill objects for PDF files matching +path_spec+
    def load(path_spec)
      Dir[path_spec].each_with_object(new) do |filename,memo|
        memo << SpsBill::Bill.new(filename)
      end
    end

  end

  # Returns a hash of total bill amounts by month
  # [[month,amount]]
  def total_amounts
    each_with_object([]) do |bill,memo|
      memo << [bill.invoice_month.to_s,bill.total_amount]
    end
  end

  # Returns a hash of electricity_usages by month
  # [[month,kwh,rate,amount]]
  def electricity_usages
    each_with_object([]) do |bill,memo|
      bill.electricity_usage.each do |usage|
        memo << [bill.invoice_month.to_s,usage[:kwh],usage[:rate],usage[:amount]]
      end
    end
  end

  # Returns a hash of gas_usages by month
  # [[month,kwh,rate,amount]]
  def gas_usages
    each_with_object([]) do |bill,memo|
      bill.gas_usage.each do |usage|
        memo << [bill.invoice_month.to_s,usage[:kwh],usage[:rate],usage[:amount]]
      end
    end
  end

  # Returns a hash of water_usages by month
  # [[month,kwh,rate,amount]]
  def water_usages
    each_with_object([]) do |bill,memo|
      bill.water_usage.each do |usage|
        memo << [bill.invoice_month.to_s,usage[:cubic_m],usage[:rate],usage[:amount]]
      end
    end
  end

end