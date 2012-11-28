module Galcon
  module Strategy
    class Future
      include FromHash
      extend Forwardable
      attr_accessor :world
      def_delegators :world, :planets, :fleets
      
      def planet_size_simple(planet)
        planet_fleets = fleets.select { |x| x.mission.target == planet }
        fleet_net = 0
        planet_fleets.each do |fleet|
          if fleet.player == planet.player
            fleet_net += fleet.size
          else
            fleet_net -= fleet.size
          end
        end
        (planet.ship_count + fleet_net).abs
      end
      
      def planet_sim(planet,ops)
        planet_fleets = fleets.select { |x| x.mission.target == planet }.map { |x| x.clone }
        planet = planet.clone
        planet_fleets.each { |x| x.mission.target = planet }
        
        ops[:turns].times do |i|
          planet.grow!
          planet_fleets.each do |fleet|
            fleet.mission.advance!
          end
          planet_fleets = planet_fleets.reject { |x| x.mission.at_target? }
        end
        
        planet
      end
      def planet_size_sim(planet,ops)
        planet_sim(planet,ops).ship_count
      end
      
      def planet(planet, ops={})
        planet_sim(planet,ops)
      end
      
      def planet_size(planet, ops={})
        if ops[:turns]
          planet_size_sim(planet,ops)
        else
          planet_size_simple(planet)
        end
      end
    end
  end
end