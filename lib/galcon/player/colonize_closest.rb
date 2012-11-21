module Galcon
  module Player
    class ColonizeClosest < Base
      def calc_moves
        my_planets.map do |planet|
          target = closest_unowned(planet)
          target ? Move.new(:source => planet, :target => target, :size => planet.ship_count) : nil
        end.select { |x| x }
      end
      def closest_unowned(planet)
        unowned = world.planets.reject { |x| x.player }
        unowned.sort_by { |x| x.dist(planet) }.first
      end
    end
  end
end