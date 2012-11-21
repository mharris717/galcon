module Galcon
  class Occupation
    include FromHash
    attr_accessor :player, :ship_count
    def size; ship_count; end
    
    def grow!(planet)
      self.ship_count += planet.growth_rate
    end
    
    def add(fleet)
      if fleet.player == player
        reinforce fleet
      else
        attack fleet
      end
    end
    
    def reinforce(fleet)
      self.ship_count += fleet.ship_count
    end
    
    def attack(fleet)
      if fleet.size <= size
        self.ship_count -= fleet.size
      else
        self.ship_count = fleet.size - size
        self.player = fleet.player
      end
    end
  end
end