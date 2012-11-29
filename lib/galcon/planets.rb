module Galcon
  class Planets
    class UnknownPlayerTypeError < RuntimeError
      include FromHash
      attr_accessor :player
    end
    
    include FromHash
    fattr(:planets) { [] }
    
    include Enumerable
    extend Forwardable
    def_delegators :planets, :each, :size, :[]
    
    fattr(:planet_dist_order_hash) do
      res = {}
      each do |source|
        other = planets - [source]
        res[source] = other.sort_by { |x| x.dist(source) }
      end
      res
    end
    
    def closest(source,ops={})
      if ops.has_key?(:player)
        o = ops
        o = {:player => [ops[:player],source.player]} if [:not_mine,:enemy].include?(ops[:player])
        return nil if list(o).empty?
      end
      other = planet_dist_order_hash[source]
      other.find do |planet|
        if ops.has_key?(:player)
          if ops[:player] == :enemy
            planet.player && planet.player != source.player
          elsif ops[:player] == :not_mine
            planet.player != source.player
          else
            planet.player == ops[:player]
          end
        else
          true
        end
      end
    end
    
    fattr(:by_player) do
      res = Hash.new { |h,k| h[k] = [] }
      each do |planet|
        res[planet.player] << planet
      end
      res
    end
    def players
      by_player.keys.select { |x| x }
    end
    def list(ops)
      if ops[:player].kind_of?(Array)
        type,base = *ops[:player]
        if type == :enemy
          enemies = players - [base]
          enemies.map { |x| by_player[x] }.flatten
        elsif type == :not_mine
          enemies = players - [base] + [nil]
          enemies.map { |x| by_player[x] }.flatten
        else
          raise UnknownPlayerTypeError.new(:player => ops[:player])
        end
      else
        by_player[ops[:player]]
      end
    end
    
    def to_fresh
      self.by_player!
      self
    end
  end
end