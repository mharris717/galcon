%w(future).each do |f|
  load File.dirname(__FILE__) + "/strategy/#{f}.rb"
end