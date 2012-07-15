class PDF::Reader::PositionalTextReceiver < PDF::Reader::PageTextReceiver

  # record text that is drawn on the page
  def show_text(string) # Tj
    raise PDF::Reader::MalformedPDFError, "current font is invalid" if @state.current_font.nil?
    newx, newy = @state.trm_transform(0,0)
    newy_approx = fuzzy_y(newy)
    @content[newy_approx] ||= {}
    @content[newy_approx][newx] = @state.current_font.to_utf8(string)
  end

  # Returns a fuzzy y positioning value
  def fuzzy_y(actual_y)
    (actual_y / 5).round(0) * 5
  end

  # override content accessor
  def content
    @content
  end

end
