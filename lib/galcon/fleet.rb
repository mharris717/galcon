module Galcon
  class Fleet
    include FromHash
    attr_accessor :player, :ship_count
    attr_accessor :mission, :loc
    
    copy_method :ship_count, :size
    
    def goto(planet)
      self.mission = Mission.new(:target => planet, :fleet => self)
    end
  end
end