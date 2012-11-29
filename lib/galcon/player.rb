%w(base colonize_closest future_user).each do |f|
  load File.dirname(__FILE__) + "/player/#{f}.rb"
end