# SpsBill::BillCollection is an Array-like class that represents a collection
# of SP Services PDF bills.
#
# The <tt>load</tt> method is used to initialise the collection given a path specification.
#
# A range of collection methods are provided to extract sets of data
# from the entire collection (e.g. <tt>electricity_usages</tt>).
#
class SpsBill::BillCollection < Array

  class << self

    # Returns an array of Bill objects for PDF files matching +path_spec+.
    # +path_spec+ may be either:
    # - an array of filenames e.g. ['data/file1.pdf','file2.pdf']
    # - or a single file or path spec e.g. './somepath/file1.pdf' or './somepath/*.pdf'
    def load(path_spec)
      path_spec = Dir[path_spec] unless path_spec.class <= Array
      path_spec.each_with_object(new) do |filename,memo|
        memo << SpsBill::Bill.new(filename)
      end
    end

  end

  # Returns the suitable array of headers for +dataset_selector+
  def headers(dataset_selector)
    case dataset_selector
    when :total_amounts
      %w(invoice_month amount)
    when :electricity_usages
      %w(invoice_month kwh rate amount)
    when :gas_usages
      %w(invoice_month kwh rate amount)
    when :water_usages
      %w(invoice_month cubic_m rate amount)
    when :all_data
      %w(invoice_month measure kwh cubic_m rate amount)
    end
  end

  # Returns an array of all data by month
  #   [[month,measure,kwh,cubic_m,rate,amount]]
  # measure: total_charges,electricity,gas,water
  def all_data
    total_amounts(:all) + electricity_usages(:all) + gas_usages(:all) + water_usages(:all)
  end

  # Returns an array of total bill amounts by month
  #   [[month,amount]]
  # when +style+ is :solo, returns minimal array to describe this data set in isolation,
  # else returns a normalised sparse array that is common to all data sets
  def total_amounts(style=:solo)
    each_with_object([]) do |bill,memo|
      if style==:solo
        memo << [bill.invoice_month.to_s,bill.total_amount]
      else
        memo << [bill.invoice_month.to_s,'total_charges',nil,nil,nil,bill.total_amount]
      end
    end
  end

  # Returns an array of electricity_usages by month
  #   [[month,kwh,rate,amount]]
  # when +style+ is :solo, returns minimal array to describe this data set in isolation,
  # else returns a normalised sparse array that is common to all data sets
  def electricity_usages(style=:solo)
    each_with_object([]) do |bill,memo|
      bill.electricity_usage.each do |usage|
        if style==:solo
          memo << [bill.invoice_month.to_s,usage[:kwh],usage[:rate],usage[:amount]]
        else
          memo << [bill.invoice_month.to_s,'electricity',usage[:kwh],nil,usage[:rate],usage[:amount]]
        end
      end
    end
  end

  # Returns an array of gas_usages by month
  #   [[month,kwh,rate,amount]]
  # when +style+ is :solo, returns minimal array to describe this data set in isolation,
  # else returns a normalised sparse array that is common to all data sets
  def gas_usages(style=:solo)
    each_with_object([]) do |bill,memo|
      bill.gas_usage.each do |usage|
        if style==:solo
          memo << [bill.invoice_month.to_s,usage[:kwh],usage[:rate],usage[:amount]]
        else
          memo << [bill.invoice_month.to_s,'gas',usage[:kwh],nil,usage[:rate],usage[:amount]]
        end
      end
    end
  end

  # Returns an array of water_usages by month
  #   [[month,kwh,rate,amount]]
  # when +style+ is :solo, returns minimal array to describe this data set in isolation,
  # else returns a normalised sparse array that is common to all data sets
  def water_usages(style=:solo)
    each_with_object([]) do |bill,memo|
      bill.water_usage.each do |usage|
        if style==:solo
          memo << [bill.invoice_month.to_s,usage[:cubic_m],usage[:rate],usage[:amount]]
        else
          memo << [bill.invoice_month.to_s,'water',nil,usage[:cubic_m],usage[:rate],usage[:amount]]
        end
      end
    end
  end

end