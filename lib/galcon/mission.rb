module Galcon
  class Mission
    include FromHash
    attr_accessor :target, :fleet
    
    def advance!
      fleet.loc = fleet.loc.move_toward(target.loc)
      reach_target! if at_target?
    end
    
    def at_target?
      fleet.loc.eq? target.loc
    end
    
    def reach_target!
      target.occupation.add fleet
    end
  end
end