require 'date'

# Main Bill class for reading SP Services PDF bills
#
class SpsBill::Bill
  include SpsBill::BillParser

  attr_reader :source_file, :reader

  # accessors for the various bill components
  attr_reader :account_number,:total_amount,:invoice_date,:invoice_month
  attr_reader :electricity_usage,:gas_usage,:water_usage

  # +source+ is a file name or stream-like object
  def initialize(source)
    @source_file = source
    @reader = PDF::StructuredReader.new(source_file) if source_file
    do_complete_parse
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