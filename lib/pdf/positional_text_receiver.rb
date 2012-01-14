require 'pdf-reader'

module PDF
  class Reader
    class PositionalTextReceiver < PDF::Reader::PageTextReceiver

      # record text that is drawn on the page
      def show_text(string) # Tj
        raise PDF::Reader::MalformedPDFError, "current font is invalid" if current_font.nil?
        at = transform(Point.new(0,0))
        @content[at.y] ||= {}
        @content[at.y][at.x] = current_font.to_utf8(string)
      end

      # override content accessor
      def content
        @content
      end

    end
  end
end