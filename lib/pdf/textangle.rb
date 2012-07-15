class PDF::Reader::Textangle
  attr_reader :reader

  # +structured_reader+ is a PDF::StructuredReader
  def initialize(structured_reader,&block)
    @reader = structured_reader
    instance_eval( &block ) if block
  end

  def text

  end

  def page(value)

  end

  def above(value)

  end

  def bellow(value)

  end

  def left_of(value)

  end

  def right_of(value)

  end
end
