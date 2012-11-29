module Galcon
  module Player
    class ColonizeClosest < Base
      fattr(:frac) { 1 }
      def calc_moves
        my_planets.map do |planet|
          target = best_target(planet)
          s = (planet.ship_count.to_f*frac).to_i
          target ? Move.new(:source => planet, :target => target, :size => s) : nil
        end.select { |x| x }
      end

      def closest_unowned(planet)
        world.planets.closest(planet,:player => nil)
      end
      def closest_enemy(planet)
        world.planets.closest(planet, :player => :enemy)
      end
      
      def best_target(planet)
        closest_unowned(planet) || closest_enemy(planet)
      end
    end
  end
end

