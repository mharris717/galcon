%w(base colonize_closest).each do |f|
  load File.dirname(__FILE__) + "/player/#{f}.rb"
end