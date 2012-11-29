module Galcon
  class World
    include FromHash
    
    def players=(ps)
      ps.each { |x| x.world = self }
      @players = ps
    end
    def players
      @players ||= []
    end
    
    def planets=(x)
      x = Planets.new(:planets => x) if x.kind_of?(Array)
      @planets = x
    end
    def planets
      @planets ||= Planets.new
    end
    
    def fleets=(x)
      x = Fleets.new(:planets => x) if x.kind_of?(Array)
      @fleets = x
    end
    def fleets
      @fleets ||= Fleets.new
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
      
      self.planets = planets.to_fresh
      self.fleets = fleets.to_fresh
    end
    
    def move(source,target,size)
      self.fleets << source.fleet_to(target,size)
    end
    
    def active_players
      (planets.players + fleets.players).uniq
    end
    
    def active?
      players = active_players
      raise "bad" if players.empty?
      players.size > 1
    end
    
    def winner
      active_players.tap { |arr| raise "no winner" unless arr.size == 1 }.first
    end
    
    fattr(:runner) { Runner::Printing.new(:world => self) }
    
    def run!(*args)
      runner.run!(*args)
    end
    

  end
  
end