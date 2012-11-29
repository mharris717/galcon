require 'mharris_ext'

%w(ext planet planets fleets occupation fleet cord world runner mission player move table strategy).each do |f|
  load File.dirname(__FILE__) + "/galcon/#{f}.rb"
end