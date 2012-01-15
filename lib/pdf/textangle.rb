class PDF::Reader::Textangle
  attr_reader :reader

  # +source+ is a file name or stream-like object
  def initialize(source)
    @reader = PDF::Reader.new(source)
  end

  # Returns positional text content collection
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

  private

    def load_content(page)
      receiver = PDF::Reader::PositionalTextReceiver.new
      reader.page(page).walk(receiver)
      receiver.content
    end

end
