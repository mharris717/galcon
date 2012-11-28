module Galcon
  module Player
    class Base
      include FromHash
      attr_accessor :player, :world
      def my_planets
        world.planets.list(:player => player)
      end
      def my_fleets
        world.fleets.list(:player => player)
      end
    end
  end
end