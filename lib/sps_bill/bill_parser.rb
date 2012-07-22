require 'date'

# all the bill scanning and parsing intelligence
module SpsBill::BillParser

  ELECTRICITY_SERVICE_HEAD = "Electricity Services"
  GAS_SERVICE_HEAD = "Gas Services by City Gas Pte Ltd"
  WATER_SERVICE_HEAD = "Water Services by Public Utilities Board"

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
    @account_number = reader.text_in_region(383.0,999.0,785.0,790.0,1).flatten.join('')
  end

  # Command: extracts the total amount due for the current month
  def parse_total_amount
    @total_amount = if ref = reader.text_position(/^Total Current Charges due on/)
      total_parts = reader.text_in_region(ref[:x] + 1,400.0,ref[:y] - 1,ref[:y] + 1,1)
      total_parts.flatten.first.to_f
    end
  end

  # Command: extracts the invoice date
  def parse_invoice_date
    @invoice_date = if ref = reader.text_position("Dated")
      date_parts = reader.text_in_region(ref[:x] + 1,999.0,ref[:y] - 1,ref[:y] + 1,1)
      Date.parse(date_parts.first.join('-'))
    end
  end

  # Command: extracts the invoice month (as Date, set to 1st of the month)
  def parse_invoice_month
    @invoice_month = if ref = reader.text_position("Dated")
      date_parts = reader.text_in_region(ref[:x] + 1,999.0,ref[:y] - 1,ref[:y] + 1,1)
      m_parts = reader.text_in_region(ref[:x]-200,ref[:x]-1,ref[:y] - 1,ref[:y] + 1,1)
      Date.parse("#{date_parts.first.last}-#{m_parts.first.first}-01")
    end
  end

  # Command: extracts an array of electricity usage charges. Each element is a Hash:
  #   { kwh: float, rate: float, amount: float }
  def parse_electricity_usage
    @electricity_usage = if upper_ref = reader.text_position(ELECTRICITY_SERVICE_HEAD)
      lower_ref = reader.text_position(GAS_SERVICE_HEAD)
      lower_ref ||= reader.text_position(WATER_SERVICE_HEAD)
      if lower_ref
        raw_data = reader.text_in_region(240.0,450.0,lower_ref[:y]+1,upper_ref[:y],1)
        raw_data.map{|l| {:kwh => l[0].gsub(/kwh/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
      end
    end
  end

  # Command: extracts an array of gas usage charges. Each element is a Hash:
  #   { kwh: float, rate: float, amount: float }
  def parse_gas_usage
    @gas_usage = if upper_ref = reader.text_position(GAS_SERVICE_HEAD)
      if lower_ref = reader.text_position(WATER_SERVICE_HEAD)
        raw_data = reader.text_in_region(240.0,450.0,lower_ref[:y]+1,upper_ref[:y],1)
        raw_data.map{|l| {:kwh => l[0].gsub(/kwh/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
      end
    end
  end

  # Command: extracts an array of water usage charges. Each element is a Hash:
  #   { cubic_m: float, rate: float, amount: float }
  def parse_water_usage
    @water_usage = if upper_ref = reader.text_position(WATER_SERVICE_HEAD)
      if lower_ref = reader.text_position("Waterborne Fee")
        raw_data = reader.text_in_region(240.0,450.0,lower_ref[:y]+1,upper_ref[:y],1)
        raw_data.map{|l| {:cubic_m => l[0].gsub(/cu m/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
      end
    end
  end

end