module Galcon
  module Runner
    class Base
      include FromHash
      attr_accessor :world
    
      def before_run; end
      def before_turn; end
      def after_turn; end
      def after_run; end
    
      extend Forwardable
      def_delegators :world, :winner, :active?
    
      fattr(:current_turn) { 0 }
      def advance!
        before_turn
        world.advance!
        after_turn
        self.current_turn += 1
      end
    
      def run!(max_turns=999)
        before_run
        while active? && current_turn < max_turns
          advance!
          raise "end" if current_turn > 200
        end
        after_run
        puts "Last turn #{current_turn} #{winner}"
      end
    end
  end
end