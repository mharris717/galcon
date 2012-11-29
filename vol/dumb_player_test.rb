def fresh_world(grid_size,num_planets)
  world = Galcon::World.new
  world = Galcon::PrintingWorld.new(:world => world)
  
  random_cords = lambda do |num|
    cords = []
    (0...grid_size).each do |x|
      (0...grid_size).each do |y|
        cords << [x,y] unless (x == 0 && y == 0) || (x == grid_size-1 && y == grid_size-1)
      end
    end
    cords = cords.sort_by { |x| rand() }[0...num]
  end
  
  random_planets = lambda do |cords|
    ps = []
    cords.each do |c|
      ps << Galcon::Planet.new(:growth_rate => rand(10)+1, :loc => c.to_cord, :ship_count => rand(30))
    end
    ps
  end
  
  sym_planets = lambda do
    cords = random_cords[num_planets*5]
    cords = cords.select { |c| c[0] > c[1] }[0...(num_planets/2)]
    left = random_planets[cords]
    right = left.map do |planet|
      c = [grid_size-planet.loc.x-1,grid_size-planet.loc.y-1].to_cord
      flip = planet.clone
      flip.location = c
      flip
    end
    left + right
  end

  ps = []
  ps << Galcon::Planet.new(:player => :red, :growth_rate => 5, :loc => [0,0].to_cord, :ship_count => 100)
  ps << Galcon::Planet.new(:player => :blue, :growth_rate => 5, :loc => [grid_size-1,grid_size-1].to_cord, :ship_count => 100)

  ps += sym_planets[]
  #ps.map { |x| x.loc }.sort.each { |x| puts x }
  world.planets = ps

  player1 = Galcon::Player::ColonizeClosest.new(:player => :red,  :world => world, :frac => 0.5)
  player2 = Galcon::Player::FutureUser.new(:player => :blue, :world => world)
  world.players << player1
  world.players << player2
  
  world
end

def run_sims!
  wins = Hash.new { |h,k| h[k] = 0 }
  (0...1).each do |i|
    world = fresh_world(10,20)
    world.run!
    wins[world.winner] += 1
    puts wins.inspect
    #raise "foo" if world.winner == :red
  end

  puts wins.inspect
end

def profile!
  require 'ruby-prof'

  result = RubyProf.profile do
    run_sims!
  end

  File.open("tmp/profile.html","w") do |f|
    printer = RubyProf::GraphHtmlPrinter.new(result)
    printer.print(f, {})
  end
end

run_sims!
#profile!

print_summary = lambda do
  total = player.my_planets.map { |x| x.ship_count }.sum + player.my_fleets.map { |x| x.size }.sum
  str = "#{player.my_planets.size} #{world.fleets.size} #{total}"
  fleet = player.my_fleets.map { |x| x.to_s }.join("\n")
  #puts "#{str}\n#{fleet}\n\n"
  puts str
end

#world.run! 

