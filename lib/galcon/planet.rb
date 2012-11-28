module Galcon
  class Planet
    include FromHash
    attr_accessor :growth_rate, :location
    fattr(:occupation) { Occupation.new(:planet => self) }
    
    extend Forwardable
    def_delegators :occupation, "player","player=","ship_count","ship_count=","add",:fleet_to,:grow!
    copy_method :location, :loc
    def_delegators :location, :dist, :x, :y
    
    def <=>(x)
      loc <=> x.loc
    end
    
    def clone
      res = klass.new(:growth_rate => growth_rate, :location => location)
      if occupation
        res.occupation = occupation.clone
        res.occupation.planet = res
      end
      res
    end
  end
end