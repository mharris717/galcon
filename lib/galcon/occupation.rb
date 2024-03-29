module Galcon
  class Occupation
    include FromHash
    attr_accessor :player, :ship_count, :planet
    def size; ship_count; end
    
    def grow!
      self.ship_count += planet.growth_rate if player
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
    
    def fleet_to(target,size)
      self.ship_count -= size
      res = Fleet.new(:player => player, :size => size, :loc => planet.loc, :source => planet)
      res.goto target
      res
    end
    
    def clone
      klass.new(:player => player, :ship_count => ship_count)
    end
  end
end