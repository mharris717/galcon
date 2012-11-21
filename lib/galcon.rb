require 'mharris_ext'

%w(planet occupation fleet cord).each do |f|
  load File.dirname(__FILE__) + "/galcon/#{f}.rb"
end