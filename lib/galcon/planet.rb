module Galcon
  class Planet
    include FromHash
    attr_accessor :growth_rate, :location
    fattr(:occupation) { Occupation.new(:planet => self) }
    
    extend Forwardable
    def_delegators :occupation, "player","player=","ship_count","ship_count=","add",:fleet_to,:grow!
    copy_method :location, :loc
    def_delegators :location, :dist, :x, :y
  end
end