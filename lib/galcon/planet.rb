module Galcon
  class Planet
    include FromHash
    attr_accessor :growth_rate, :location
    fattr(:occupation) { Occupation.new }
    
    extend Forwardable
    def_delegators :occupation, "player","player=","ship_count","ship_count=","add"
    
    def grow!
      occupation.grow! self
    end
    
    
  end
end