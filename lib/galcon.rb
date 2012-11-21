require 'mharris_ext'

%w(planet occupation fleet cord ext).each do |f|
  load File.dirname(__FILE__) + "/galcon/#{f}.rb"
end