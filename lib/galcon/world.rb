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
      active_players.first
    end
    
    def run!(n=nil)
      if n
        n.times do
          advance!
        end
      else
        i = 0
        while active?
          advance!
          i += 1
          raise "end" if i > 200
        end
        puts "Last turn #{i} #{winner}"
      end
    end
    
    
  end
  
  class PrintingWorld
    include FromHash
    attr_accessor :world
    def method_missing(sym,*args,&b)
      world.send(sym,*args,&b)
    end
    def to_html
      Table.new(:world => self).to_s
    end
    
    def run!(n=nil)
      styles = (0...40).map do |gr|
        s = gr * 5 + 10
        "<style type='text/css'>.size-#{gr} {min-height: #{s}px; min-width: #{s}px; max-height: #{s}px; max-width: #{s}px; height: #{s}px; width: #{s}px;}</style>"
      end.join("\n")
      File.create("tmp/state.html",'<html><head>
      <style type="text/css">td {height: 60px; width: 60px; font-size: 65%; text-align: center; }</style>
      <style type="text/css">div {vertical-align: middle; }</style>
      <style type="text/css">.red {background-color:red;}</style>
      <style type="text/css">.blue {background-color:blue;}</style>
      <style type="text/css">.gray {background-color:gray;}</style>
      <style type="text/css">.grid {float: left; margin:30px; border-style: solid; border-width: 1px; border:color: black; }</style>' + styles + '
      </head><body>')
      File.append "tmp/state.html",to_html
      if n
        n.times do
          advance!
          File.append "tmp/state.html",to_html
        end
      else
        i = 0
        while active?
          advance!
          File.append "tmp/state.html",to_html
          i += 1
          raise "end" if i > 200
        end
        puts "Last turn #{i} #{winner}"
      end
      File.append "tmp/state.html", "Done</body></html>"
    end
  end
end