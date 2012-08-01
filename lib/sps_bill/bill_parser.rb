require 'date'

# all the bill scanning and parsing intelligence
module SpsBill::BillParser

  ELECTRICITY_SERVICE_HEADER = /Electricity Services/i
  ELECTRICITY_SERVICE_FOOTER = /Gas Services|Water Services/i
  GAS_SERVICE_HEADER = /Gas Services/i
  GAS_SERVICE_FOOTER = /Water Services/i
  WATER_SERVICE_HEADER = /Water Services/i
  WATER_SERVICE_FOOTER = /Waterborne Fee/i

  # Returns a collection of parser errors
  def errors
    @errors ||= []
  end

  # Command: scans and extracts billing details from the pdf doc
  def do_complete_parse
    return unless reader
    methods.select{|m| m =~ /^parse_/ }.each do |m|
      begin
        send(m)
      rescue => e
        errors << "failure parsing #{source_file}:#{m} #{e.inspect}"
      end
    end
  end

  # Command: extracts the account number
  def parse_account_number
    region = reader.bounding_box do
      exclusive!
      below 'Dated'
      above 'Type'
      right_of 'Account No'
    end
    # text will be returned like this:
    #   [[":", "8123123123"]]
    @account_number = region.text.flatten.last
  end

  # Command: extracts the total amount due for the current month
  def parse_total_amount
    region = reader.bounding_box do
      inclusive!
      below /^Total Current Charges due on/
      above /^Total Current Charges due on/
      right_of /^Total Current Charges due on/
      left_of 400.0
    end
    # text will be returned like this:
    #   [["Total Current Charges due on 14 Jun 2011 (Tue)", "251.44"]]
    @total_amount = region.text.flatten.last.to_f
  end

  # Command: extracts the invoice date
  def parse_invoice_date
    region = reader.bounding_box do
      inclusive!
      below 'Dated'
      above 'Dated'
      right_of 'Dated'
    end
    # text will be returned like this:
    #   [["Dated", "31", "May", "2011"]]
    date_string = region.text.flatten.slice(1..3).join('-')
    @invoice_date = Date.parse(date_string)
  end

  # Command: extracts the invoice month (as Date, set to 1st of the month)
  def parse_invoice_month
    region = reader.bounding_box do
      inclusive!
      below 'Dated'
      above 'Dated'
    end
    # text will be returned like this:
    #   [["May", "11", "Bill", "Dated", "31", "May", "2011"]]
    date_array = ['01'] + region.text.flatten.slice(0..1)
    if (yy = date_array[2]).length == 2
      date_array[2] = "20#{yy}" # WARNING: converting 2-digit date. Assumed to be 21st C
    end
    @invoice_month = Date.parse(date_array.join('-'))
  end

  # Command: extracts an array of electricity usage charges. Each element is a Hash:
  #   { kwh: float, rate: float, amount: float }
  def parse_electricity_usage
    region = reader.bounding_box do
      exclusive!
      below ELECTRICITY_SERVICE_HEADER
      above ELECTRICITY_SERVICE_FOOTER
      right_of 240.0
      left_of 450.0
    end
    # text will be returned like this:
    #   [["4 kWh", "0.2410", "0.97"], ["616 kWh", "0.2558", "157.57"]]
    @electricity_usage = unless (raw_data = region.text).empty?
      raw_data.map{|l| {:kwh => l[0].gsub(/kwh/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
    end
  end

  # Command: extracts an array of gas usage charges. Each element is a Hash:
  #   { kwh: float, rate: float, amount: float }
  def parse_gas_usage
    region = reader.bounding_box do
      exclusive!
      below GAS_SERVICE_HEADER
      above GAS_SERVICE_FOOTER
      right_of 240.0
      left_of 450.0
    end
    # text will be returned like this:
    #   [["4 kWh", "0.2410", "0.97"], ["616 kWh", "0.2558", "157.57"]]
    @gas_usage = unless (raw_data = region.text).empty?
      raw_data.map{|l| {:kwh => l[0].gsub(/kwh/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
    end
  end

  # Command: extracts an array of water usage charges. Each element is a Hash:
  #   { cubic_m: float, rate: float, amount: float }
  def parse_water_usage
    region = reader.bounding_box do
      exclusive!
      below WATER_SERVICE_HEADER
      above WATER_SERVICE_FOOTER
      right_of 240.0
      left_of 450.0
    end
    # text will be returned like this:
    #   [["36.1 Cu M", "1.1700", "42.24"], ["-3.0 Cu M", "1.4000", "-4.20"]]
    @water_usage = unless (raw_data = region.text).empty?
      raw_data.map{|l| {:cubic_m => l[0].gsub(/cu m/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
    end
  end

end