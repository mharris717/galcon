require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Galcon" do
  let(:world) do
    Galcon::World.new(:planets => planets, :fleets => fleets)
  end
  let(:planets) do
    res = []
    res << Galcon::Planet.new(:player => :red, :growth_rate => 10, :ship_count => source_ships, :loc => [0,0].to_cord)
    res << Galcon::Planet.new(:player => target_color, :growth_rate => 5, :ship_count => 10, :loc => [3,0].to_cord)
    res
  end
  let(:target_color) { :red }
  let(:source_ships) { 20 }
  let(:fleets) { [] }
  
  describe 'one tick' do
    before do
      world.advance!
    end
    it 'should grow planet' do
      planets.first.ship_count.should == 30
    end
  end
  
  describe 'three ticks' do
    before do
      3.times { world.advance! }
    end
    it 'grows planet' do
      planets.first.ship_count.should == 50
    end
  end
  
  describe 'move' do
    let(:source) { planets.first }
    let(:target) { planets.last }
    
    before do
      world.move source,target,5
      3.times { world.advance! }
    end
    
    it 'source ships' do
      source.ship_count.should == 45
    end
    
    it 'target ships' do
      target.ship_count.should == 30
    end
  end
  
  describe 'move attack' do
    let(:source) { planets.first }
    let(:target) { planets.last }
    let(:target_color) { :blue }
    
    before do
      world.move source,target,5
      3.times { world.advance! }
    end
    
    it 'source ships' do
      source.ship_count.should == 45
    end
    
    it 'target ships' do
      target.ship_count.should == 20
    end
    it 'target color' do
      target.player.should == :blue
    end
  end
  
  describe 'move attack' do
    let(:source) { planets.first }
    let(:target) { planets.last }
    let(:target_color) { :blue }
    let(:source_ships) { 100 }
    
    before do
      world.move source,target,80
      3.times { world.advance! }
    end
    
    it 'source ships' do
      source.ship_count.should == 50
    end
    
    it 'target ships' do
      target.ship_count.should == 55
    end
    it 'target color' do
      target.player.should == :red
    end
  end
    
    
  
end
