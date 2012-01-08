require 'pdf-reader'

module PDF
  class Reader
    class BillReceiver < PDF::Reader::PageTextReceiver

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

      # starting a new page
      # TODO: this is monkey-patch to fix a bug in PDF::Reader::PageTextReceiver
      def page=(page)
        @page    = page
        @objects = page.objects
        @font_stack    = [build_fonts(page.fonts)]
        @xobject_stack = [page.xobjects]
        @content = {}
        @stack   = [DEFAULT_GRAPHICS_STATE.dup]
      end

    end
  end
end