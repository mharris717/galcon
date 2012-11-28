module Galcon
  class Fleets
    include FromHash
    fattr(:planets) { [] }
    
    include Enumerable
    extend Forwardable
    def_delegators :planets, :each, :size, :[]
    
    fattr(:by_player) do
      res = Hash.new { |h,k| h[k] = [] }
      each do |planet|
        res[planet.player] << planet
      end
      res
    end
    def players
      by_player.keys
    end
    def list(ops)
      by_player[ops[:player]]
    end
    
    def <<(f)
      self.planets << f
      by_player[f.player] << f
    end
    
    def to_fresh
      self.by_player!
      self
    end
  end
end