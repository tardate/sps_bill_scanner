# SpsBill::Bill represents an individual SP Services PDF bill
#
# It is initialised given a file name, and provides a range of accessors
# to get at individual data elements (e.g. <tt>electricity_usage</tt>)
#
class SpsBill::Bill
  include SpsBill::BillParser

  attr_reader :source_file

  # accessors for the various bill components
  #
  # electricity_usage charges is an array of hashed values:
  # [{ kwh: float, rate: float, amount: float }]
  # gas_usage charges is an array of hashed values:
  # [{ kwh: float, rate: float, amount: float }]
  # water_usage charges is an array of hashed values:
  # [{ cubic_m: float, rate: float, amount: float }]
  #
  attr_reader :account_number,:total_amount,:invoice_date,:invoice_month
  attr_reader :electricity_usage,:gas_usage,:water_usage

  # +source+ is a file name or stream-like object
  def initialize(source)
    @source_file = source
    do_complete_parse
  end

  # Returns the PDF reader isntance
  def reader
    @reader ||= PDF::StructuredReader.new(source_file) if source_file
  end

  # Return a pretty(-ish) text format of the core bill details
  def to_s
    %(
Account number: #{account_number}
Invoice date  : #{invoice_date}
Service month : #{invoice_month}
Total bill    : $#{total_amount}

Electricity Usage
-----------------
#{electricity_usage}

Gas Usage
---------
#{gas_usage}

Water Usage
-----------
#{water_usage}

      )
  end


end