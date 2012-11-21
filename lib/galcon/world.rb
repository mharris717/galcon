module Galcon
  class World
    include FromHash
    fattr(:planets) { [] }
    fattr(:fleets) { [] }
    attr_accessor :players
    
    def players=(ps)
      ps.each { |x| x.world = self }
      @players = ps
    end
    def players
      @players ||= []
    end
    
    def player_moves!
      players.each do |player|
        player.calc_moves.each do |move|
          move move.source,move.target,move.size
        end
      end
    end
    
    def advance!
      player_moves!
      planets.each { |x| x.grow! }
      fleets.each { |x| x.mission.advance! }
      self.fleets = fleets.reject { |x| x.mission.at_target? }
    end
    
    def move(source,target,size)
      self.fleets << source.fleet_to(target,size)
    end
  end
end