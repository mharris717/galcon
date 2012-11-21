class Object
  def klass
    self.class
  end
end

class Numeric
  def ia_round(n)
    if self == to_i
      self
    else
      round(n)
    end
  end
end