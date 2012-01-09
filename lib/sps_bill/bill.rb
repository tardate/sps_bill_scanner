require 'pdf-reader'

#
class SpsBill::Bill

  attr_reader :source, :reader

  # +source+ is a file name or stream-like object
  def initialize(source)
    @source = source
  end

  # Returns PDF::Reader
  def reader
    @reader ||= PDF::Reader.new(load_source_with_quirks)
  end

  def account_number
    @account_number ||= text_in_rect(383.0,999.0,787.0,788.0,1)[0][0]
  end

  def invoice_month
    @invoice_month ||= if ref = text_position("Dated")
      date_parts = text_in_rect(ref[:x] + 1,999.0,ref[:y] - 1,ref[:y] + 1,1)
      Date.parse(date_parts.first.join('-'))
    end
  end

  def electricity_usage
    upper_ref = text_position("Electricity Services")
    lower_ref = text_position("Gas Services by City Gas Pte Ltd")
    text_in_rect(240.0,450.0,lower_ref[:y],upper_ref[:y],1)
  end

  private

  # Returns text content collection
  def content(page=1)
    if @content.is_a?(Array) && @content[page]
      @content[page]
    else
      @content ||= []
      @content[page] = load_content(page)
    end
  end

  # Returns an array of text elements in the bounding box
  def text_in_rect(xmin,xmax,ymin,ymax,page=1)
    text_map = content(page)
    box = []
    text_map.keys.sort.reverse.each do |y|
      if y >= ymin && y<= ymax
        row = []
        text_map[y].keys.sort.each do |x|
          if x >= xmin && x<= xmax
            row << text_map[y][x]
          end
        end
        box << row unless row.empty?
      end
    end
    box
  end

  def text_position(text,page=1)
    if item = content(page).map {|k,v| if x = v.rassoc(text) ; [k,x] ; end }.compact.flatten
      { :x => item[1], :y => item[0] }
    end
  end

  # Load file as a StringIO stream, accounting for invalid format
  # where additional characters exist in the file before the %PDF start of file
  def load_source_with_quirks
    if source.respond_to?(:seek) && source.respond_to?(:read)
      source
    else
      stream = File.open(source, "rb")
      if ofs = pdf_offset(stream)
        stream.seek(ofs)
        StringIO.new(stream.read)
      else
        raise ArgumentError, "invalid file format"
      end
    end
  end

  # Returns the offset of the PDF document in the +stream+.
  # Checks up to 50 chars into the file, returns nil of no DF stream detected.
  def pdf_offset(stream)
    stream.rewind
    ofs = stream.pos
    until stream.readchar == '%' || ofs > 50
      ofs += 1
    end
    ofs < 50 ? ofs : nil
  end

  def load_content(page)
    billr = PDF::Reader::BillReceiver.new
    reader.page(page).walk(billr)
    billr.content
  end

end