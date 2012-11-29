module Galcon
  class Mission
    
    class BadAdvanceError < RuntimeError
      include FromHash
      attr_accessor :mission
      
      def to_s
        "Bad Advance, #{mission.fleet.source.loc} -> #{mission.fleet.loc} -> #{mission.target.loc}, #{mission.fleet.player}:#{mission.fleet.size}"
      end
    end
    
    include FromHash
    attr_accessor :target, :fleet
    
    def advance!
      fleet.loc = fleet.loc.move_toward(target.loc)
      reach_target! if at_target?
    rescue(Cord::SameLocError) => exp
      raise BadAdvanceError.new(:mission => self)
    end
    
    def at_target?
      fleet.loc.eq? target.loc
    end
    
    def reach_target!
      target.occupation.add fleet
    end
    
    def turns_to_target
      fleet.loc.dist(target.loc).to_f.round_up
    end
    
    def clone
      klass.new(:target => target)
    end
  end
end