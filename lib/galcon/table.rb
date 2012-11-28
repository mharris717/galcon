module Galcon
  class Table
    include FromHash
    attr_accessor :world
    
    fattr(:grid_size) do
      world.planets.map { |x| [x.x,x.y] }.flatten.max + 1
    end
    
    def to_s
      res = []
      res << "<div class='grid'><table>"
      (0...grid_size).each do |y|
        res << "<tr>"
        (0...grid_size).each do |x|
          res << cell(x,y)
        end
        res << "</tr>"
      end
      res << "</table></div>"
      res.join("\n")
    end
    
    def cell(x,y)
      planet = world.planets.find { |planet| planet.loc.x == x && planet.loc.y == y }
      return "<td></td>" unless planet
      
      size_class = "size-#{planet.growth_rate}"
      "<td><div class='#{planet.player || 'gray'} #{size_class}'>#{planet.ship_count}</div></td>"
    end
  end
end