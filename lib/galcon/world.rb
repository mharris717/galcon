module Galcon
  class World
    include FromHash
    fattr(:planets) { [] }
    fattr(:fleets) { [] }
    
    def advance!
      planets.each { |x| x.grow! }
      fleets.each { |x| x.mission.advance! }
    end
    
    def move(source,target,size)
      self.fleets << source.fleet_to(target,size)
    end
  end
end