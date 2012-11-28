require 'mharris_ext'

%w(ext planet planets fleets occupation fleet cord world mission player move table).each do |f|
  load File.dirname(__FILE__) + "/galcon/#{f}.rb"
end