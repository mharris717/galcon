module Galcon
  class Fleet
    include FromHash
    attr_accessor :player, :ship_count
    def size; ship_count; end
  end
end