module Galcon
  class Move
    include FromHash
    attr_accessor :source, :target, :size 
  end
end