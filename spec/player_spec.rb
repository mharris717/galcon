require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Galcon" do
  let(:world) do
    Galcon::World.new(:planets => planets, :fleets => fleets, :players => players)
  end
  let(:planets) do
    res = []
    res << Galcon::Planet.new(:player => :red, :growth_rate => 10, :ship_count => 50, :loc => [0,0].to_cord)
    res << Galcon::Planet.new(:player => nil, :growth_rate => 5, :ship_count => 10, :loc => [3,0].to_cord)
    res
  end
  let(:fleets) { [] }
  
  let(:players) do
    res = []
    res << Galcon::Player::ColonizeClosest.new(:player => :red)
    res
  end
  let(:player) { players.first }
  
  describe 'manual check' do
    let(:first_moves) do
      player.calc_moves
    end
    let(:first_move) { first_moves.first }
  
    before do
      world
    end
  
    it 'one move' do
      first_moves.size.should == 1
    end
    it('size'){ first_move.size.should == 50 }
    it('source') { first_move.source.should == planets[0] }
    it('target') { first_move.target.should == planets[1] }
  end
  
  describe 'thru world' do
    describe 'one tick' do
      before do
        world.advance!
      end
      let(:fleet) { world.fleets.first }
      it 'fleet count' do
        world.fleets.size.should == 1
      end
      it 'fleet size' do
        fleet.size.should == 50
      end
      it 'source size' do
        planets[0].ship_count.should == 10
      end
    end
    
    describe 'three ticks' do
      before do
        3.times { world.advance! }
      end
      it 'fleet count' do
        world.fleets.size.should == 2
      end
      it 'source size' do
        planets[0].ship_count.should == 10
      end
      it 'colonized planet' do
        planets[1].player.should == :red
      end
      it 'target ship count' do
        planets[1].ship_count.should == 40
      end
    end
    
    describe 'five ticks' do
      before do
        5.times { world.advance! }
      end
      it 'fleet count' do
        world.fleets.size.should == 0
      end
      it 'source size' do
        planets[0].ship_count.should == 30
      end
      it 'colonized planet' do
        planets[1].player.should == :red
      end
      it 'target ship count' do
        planets[1].ship_count.should == 70
      end
    end
  end
end
