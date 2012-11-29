require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def make_world(ops={})
  planets = []
  ops[:planets].each do |str|
    x,y,owner,size,growth_rate = *str.split(" ")
    if owner == 'nil'
      owner = nil
    elsif owner
      owner = owner.to_sym 
    end
    planets << Galcon::Planet.new(:loc => [x.to_i,y.to_i].to_cord, :player => owner, :ship_count => size.to_i, :growth_rate => growth_rate.to_i)
  end
  
  Galcon::World.new(:planets => planets)
end
    
    
describe "Future" do
  let(:world) do
    make_world :planets => ["0 0 red 200 5","2 0 #{target_owner} 50 5","4 0 nil 50 5","10 0 blue 50 5"]
  end
  let(:target_owner) { "nil" }
  let(:fleet_size) { 20 }
  let(:future) do
    Galcon::Strategy::Future.new(:world => world)
  end
  let(:source) { world.planets.planets[0] }
  let(:target) { world.planets.planets[1] }
  let(:other) { world.planets.planets[2] }
  let(:attack) { true }
  
  before do
    world.move(source,target,fleet_size) if attack
    world.advance!
  end
  
  describe "attacking unowned planet" do
    describe "one turn in" do
      it 'target' do
        future.planet_size(target).should == 30
      end
    
      it 'other' do
        future.planet_size(other).should == 50
      end
    end
  end
  
  describe "attacking own planet" do
    let(:target_owner) { "red" }
  
    describe "one turn in" do
      it 'target' do
        future.planet_size(target).should == 75
      end
    end
  end
  
  describe "attacking enemy planet - not winning" do
    let(:target_owner) { "blue" }
  
    describe "one turn in" do
      it 'target' do
        future.planet_size(target).should == 35
      end
    end
  end
  
  describe "attacking enemy planet - winning" do
    let(:target_owner) { "blue" }
    let(:fleet_size) { 60 }
  
    describe "one turn in" do
      it 'target' do
        future.planet_size(target).should == 5
      end
    end
  end
  
  describe "attacking enemy planet - not winning - sim close" do
    let(:target_owner) { "blue" }
  
    describe "one turn in" do
      it 'target' do
        future.planet_size(target, :turns => 2).should == 45
      end
    end
  end
  
  describe "attacking enemy planet - not winning - sim far" do
    let(:target) { world.planets.planets[3] }
    let(:fleet_size) { 80 }
  
    describe "one turn in" do
      it '2 turns later' do
        future.planet_size(target, :turns => 2).should == 65
      end
      it '8 turns later' do
        future.planet_size(target, :turns => 8).should == 50 + 5*9
      end
      it '9 turns later' do
        future.planet_size(target, :turns => 9).should == 50 + 5*10 - 80
      end
      it '10 turns later' do
        future.planet_size(target, :turns => 10).should == 50 + 5*11 - 80
        future.planet(target, :turns => 10).ship_count.should == 25
        future.planet(target, :turns => 10).player.should == :blue
      end
    end
  end
  
  describe "attacking enemy planet - winning - sim far" do
    let(:target) { world.planets.planets[3] }
    let(:fleet_size) { 130 }
  
    describe "one turn in" do
      it '2 turns later' do
        future.planet_size(target, :turns => 2).should == 65
      end
      it '8 turns later' do
        future.planet_size(target, :turns => 8).should == 50 + 5*9
      end
      it '9 turns later' do
        future.planet_size(target, :turns => 9).should == 30
      end
      it '10 turns later' do
        future.planet_size(target, :turns => 10).should == 35
        future.planet(target, :turns => 10).ship_count.should == 35
        future.planet(target, :turns => 10).player.should == :red
      end
    end
  end
  
  describe "attacking enemy planet - winning - turns based on fleet" do
    let(:fleet_size) { 80 }
    let(:target_owner) { :blue }
  
    describe "one turn in" do
      it 'when reach' do
        future.planet_size(target, :fleet => world.fleets.first).should == 20
      end
    end
  end
  
  describe "check far planet" do
    let(:fleet_size) { 80 }
    let(:target) { world.planets.planets[3] }
    let(:attack) { false }
  
    describe "one turn in" do
      it 'when reach' do
        future.planet_size(target, :source => source).should == 105
      end
    end
  end
  
  describe "check far planet" do
    let(:fleet_size) { 80 }
    let(:target) { world.planets.planets[3] }
  
    describe "one turn in" do
      it 'when reach' do
        future.planet_size(target, :source => source).should == 25
      end
    end
  end
  
  describe "error" do
    it 'errors without turns' do
      lambda { future.planet(target) }.should raise_error(Galcon::Strategy::Future::UnknownTurnsError)
    end
  end
  

end
