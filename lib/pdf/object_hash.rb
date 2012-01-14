class PDF::Reader
  class ObjectHash

    def extract_io_from(input)
      if input.respond_to?(:seek) && input.respond_to?(:read)
        input
      elsif File.file?(input.to_s)
        read_with_quirks(input)
      else
        raise ArgumentError, "input must be an IO-like object or a filename"
      end
    end

    # Load file as a StringIO stream, accounting for invalid format
    # where additional characters exist in the file before the %PDF start of file
    def read_with_quirks(input)
      stream = File.open(input.to_s, "rb")
      if ofs = pdf_offset(stream)
        stream.seek(ofs)
        StringIO.new(stream.read)
      else
        raise ArgumentError, "invalid file format"
      end
    end
    private :read_with_quirks
    
    # Returns the offset of the PDF document in the +stream+.
    # Checks up to 50 chars into the file, returns nil of no PDF stream detected.
    def pdf_offset(stream)
      stream.rewind
      ofs = stream.pos
      until stream.readchar == '%' || ofs > 50
        ofs += 1
      end
      ofs < 50 ? ofs : nil
    end
    private :pdf_offset
  end
end