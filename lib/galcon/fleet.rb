module Galcon
  class Fleet
    include FromHash
    attr_accessor :player, :ship_count
    attr_accessor :mission, :loc, :source
    
    copy_method :ship_count, :size
    
    def goto(planet)
      self.mission = Mission.new(:target => planet, :fleet => self)
    end
    
    def to_s
      "#{player}:#{size} #{loc} -> #{mission.target.loc}"
    end
    
    def clone
      res = klass.new(:player => player, :ship_count => ship_count, :loc => loc, :source => source)
      if mission
        res.mission = mission.clone
        res.mission.fleet = res
      end
      res
    end
  end
end

def return_two
  2
end