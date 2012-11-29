%w(base printing).each do |f|
  load File.dirname(__FILE__) + "/runner/#{f}.rb"
end