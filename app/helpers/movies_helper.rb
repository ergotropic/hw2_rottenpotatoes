module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def hilite_class(search, field)
    if hilite?(search, field) then {:class => 'hilite'} else {} end
  end

  def hilite?(search, field)
    search.sorts.detect {|s| s.name == field.to_s}.present?
  end

end
