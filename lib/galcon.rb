require 'mharris_ext'

%w(ext planet occupation fleet cord world mission player move).each do |f|
  load File.dirname(__FILE__) + "/galcon/#{f}.rb"
end