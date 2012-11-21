module Galcon
  module Player
    class Base
      include FromHash
      attr_accessor :player, :world
      def my_planets
        world.planets.select { |x| x.player == player }
      end
    end
  end
end