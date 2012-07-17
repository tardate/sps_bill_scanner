require 'date'

#
class SpsBill::Bill

  attr_reader :reader

  # +source+ is a file name or stream-like object
  def initialize(source)
    @reader = PDF::StructuredReader.new(source)
  end

  # Returns the account number
  def account_number
    @account_number ||= reader.text_in_rect(383.0,999.0,785.0,790.0,1).flatten.join('')
  end

  # Returns the total amount due for the current month
  def total_amount
    @total_amount ||= if ref = reader.text_position("Outstanding Balance")
      total_parts = reader.text_in_rect(ref[:x] + 1,400.0,ref[:y] - 30,ref[:y] - 1,1)
      total_parts.flatten.first.to_f
    end
  end

  # Returns the invoice date
  def invoice_date
    @invoice_date ||= if ref = reader.text_position("Dated")
      date_parts = reader.text_in_rect(ref[:x] + 1,999.0,ref[:y] - 1,ref[:y] + 1,1)
      Date.parse(date_parts.first.join('-'))
    end
  end

  # Returns the invoice month (as Date, set to 1st of the month)
  def invoice_month
    @invoice_month ||= if ref = reader.text_position("Dated")
      date_parts = reader.text_in_rect(ref[:x] + 1,999.0,ref[:y] - 1,ref[:y] + 1,1)
      m_parts = reader.text_in_rect(ref[:x]-200,ref[:x]-1,ref[:y] - 1,ref[:y] + 1,1)
      Date.parse("#{date_parts.first.last}-#{m_parts.first.first}-01")
    end
  end

  # Returns an array of electricity usage charges. Each charge is a Hash:
  # { kwh: float, rate: float, amount: float }
  def electricity_usage
    upper_ref = reader.text_position("Electricity Services")
    lower_ref = reader.text_position("Gas Services by City Gas Pte Ltd")
    raw_data = reader.text_in_rect(240.0,450.0,lower_ref[:y]+1,upper_ref[:y],1)
    raw_data.map{|l| {:kwh => l[0].gsub(/kwh/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
    # textangle = reader.bounding_box do
    #   page 1
    #   bellow "Electricity Services"
    #   above "Gas Services by City Gas Pte Ltd"
    #   right_of 240.0
    #   left_of "Total ($)"
    # end
    # textangle.text
  end

  # Returns an array of gas usage charges. Each charge is a Hash:
  # { kwh: float, rate: float, amount: float }
  def gas_usage
    upper_ref = reader.text_position("Gas Services by City Gas Pte Ltd")
    lower_ref = reader.text_position("Water Services by Public Utilities Board")
    raw_data = reader.text_in_rect(240.0,450.0,lower_ref[:y]+1,upper_ref[:y],1)
    raw_data.map{|l| {:kwh => l[0].gsub(/kwh/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
  end

  # Returns an array of water usage charges. Each charge is a Hash:
  # { cubic_m: float, rate: float, amount: float }
  def water_usage
    upper_ref = reader.text_position("Water Services by Public Utilities Board")
    lower_ref = reader.text_position("Waterborne Fee")
    raw_data = reader.text_in_rect(240.0,450.0,lower_ref[:y]+1,upper_ref[:y],1)
    raw_data.map{|l| {:cubic_m => l[0].gsub(/cu m/i,'').to_f, :rate => l[1].to_f, :amount => l[2].to_f} }
  end

  # Returns a pretty(-ish) text format of the core bill details
  def to_s

  end


end