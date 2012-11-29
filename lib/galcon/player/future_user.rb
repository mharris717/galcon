module Galcon
  module Player
    class FutureUser < Base
      def calc_moves
        res = []
        my_planets.each do |planet|
          res += planet_moves(planet)
        end
        res
      end  
      def planet_moves(source)
        res = []
        
        future = Galcon::Strategy::Future.new(:world => world)
        avail = source.ship_count
        
        unowned = world.planets.list(:player => nil).sort_by { |target| target.loc.dist(source.loc) }
        unowned.each do |target|
          if target.ship_count <= avail || true
            return res if avail == 0
            future_planet = future.planet(target, :source => source)
            future_count = future_planet.ship_count + 1
            future_count = avail if future_count > avail
            if future_planet.player != player
              #raise "bad move" if source.loc.eq?(target.loc)
              res << Move.new(:source => source, :target => target, :size => future_count)
              avail -= future_count
            end
          end
        end
        
        enemy = world.planets.list(:player => [:enemy,player]).sort_by { |target| target.loc.dist(source.loc) }
        enemy.each do |target|
          if target.ship_count <= avail || true
            return res if avail == 0
            future_planet = future.planet(target, :source => source)
            future_count = future_planet.ship_count + 1
            future_count = avail if future_count > avail
            if future_planet.player != player
              #raise "bad move" if source.loc.eq?(target.loc)
              res << Move.new(:source => source, :target => target, :size => future_count)
              avail -= future_count
            end
          end
        end
        
        res
      end 
    end
  end
end