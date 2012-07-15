
#
class SpsBill::Bill

  attr_reader :reader

  # +source+ is a file name or stream-like object
  def initialize(source)
    @reader = PDF::StructuredReader.new(source)
  end

  def account_number
    @account_number ||= reader.text_in_rect(383.0,999.0,787.0,788.0,1)[0][0]
  end

  def invoice_month
    @invoice_month ||= if ref = reader.text_position("Dated")
      date_parts = reader.text_in_rect(ref[:x] + 1,999.0,ref[:y] - 1,ref[:y] + 1,1)
      Date.parse(date_parts.first.join('-'))
    end
  end

  def electricity_usage
    upper_ref = reader.text_position("Electricity Services")
    lower_ref = reader.text_position("Gas Services by City Gas Pte Ltd")
    reader.text_in_rect(240.0,450.0,lower_ref[:y],upper_ref[:y],1)
    # textangle = reader.bounding_box do
    #   page 1
    #   bellow "Electricity Services"
    #   above "Gas Services by City Gas Pte Ltd"
    #   right_of 240.0
    #   left_of "Total ($)"
    # end
    # textangle.text
  end

end