module Galcon
  class Cord
    include FromHash
    attr_accessor :x, :y
    
    def x=(v)
      @x = v.ia_round(5)
    end
    def y=(v)
      @y = v.ia_round(5)
    end
    
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
    
    def move_toward(c)
      exist = move_toward_cache[c]
      return exist if exist
      res = move_toward_calc(c)
      move_toward_cache[c] = res
      res
    end
    
    def move_toward_calc(c)
      if x == c.x && y == c.y
        raise "same"
      elsif x == c.x
        sign = (c.y > y) ? 1 : -1
        [x,y+sign].to_cord
      elsif y == c.y
        sign = (c.x > x) ? 1 : -1
        [x+sign,y].to_cord
      elsif dist(c) <= 1
        c
      else
        move_toward_calc_inner(c)
      end
    end

      
    
    def move_toward_calc_inner(c)
      x_diff = (x - c.x).abs
      y_diff = (y - c.y).abs
      
      x_perc = x_diff.to_f / (x_diff.to_f + y_diff.to_f)
      y_perc = 1.0 - x_perc
      
      #x_perc *= -1 if x > c.x
      #y_perc *= -1 if y > c.y
      
      x_frac = x_perc / y_perc
      x_frac2 = x_frac**2
      
      y_frac = y_perc / x_perc
      y_frac2 = y_frac**2
      
      x_sign = (c.x > x) ? 1 : -1
      y_sign = (c.y > y) ? 1 : -1
      
      #%w(x y c.x c.y x_diff y_diff x_perc y_perc).each do |name|
        #val = eval(name)
        #puts "#{name}: #{val}"
      #end
      
      res = klass.new
      res.x = x + (x_frac2 / (1 + x_frac2))**0.5 * x_sign
      res.y = y + (y_frac2 / (1 + y_frac2))**0.5 * y_sign
      
      res
      
      # x**2 + y**2 = 1
      # x * x_frac = y
      # x**2 + (x / x_frac)**2 = 1
      # x**2 + (x**2 / x_frac**2)
      # x**2 + (x**2 / x_frac2) = 1
      # x**2 * (1 + x_frac2) = x_frac2
      # x**2 = x_frac2 / (1 + x_frac2)
      # x = (x_frac2 / (1 + x_frac2))**0.5
    end
    
    def eq?(c)
      c.x == x && c.y == y
    end
    
    fattr(:move_toward_cache) { {} }
    
    class << self
      fattr(:cache) do
        Hash.new { |h,k| h[k] = new(:x => k[0], :y => k[1]) }
      end
      def get(x,y)
        cache[[x,y]]
      end
    end
    
    def <=>(c)
      [x,y] <=> [c.x,c.y]
    end
  end
end

class Array
  def to_cord
    Galcon::Cord.get(self[0],self[1])
  end
end