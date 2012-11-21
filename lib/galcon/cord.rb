module Galcon
  class Cord
    include FromHash
    attr_accessor :x, :y
    
    def to_cord
      self
    end
    
    def to_s
      "#{x},#{y}"
    end
    
    def dist(c)
      res = (x - c.x)**2 + (y - c.y)**2
      res**0.5
    end
  end
end

class Array
  def to_cord
    Galcon::Cord.new(:x => self[0], :y => self[1])
  end
end