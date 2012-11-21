require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Galcon" do
  describe "growth" do
    let(:planet) do
      Galcon::Planet.new(:growth_rate => 5, :player => :red, :ship_count => 10)
    end
    
    it 'owned by red' do
      planet.player.should == :red
    end
    
    describe "after growth" do
      before do
        planet.grow!
      end
      it 'should have grown' do
        planet.ship_count.should == 15
      end
    end
    
    describe "reinforcement" do
      let(:fleet) do
        Galcon::Fleet.new(:player => :red, :ship_count => 5)
      end
      before do
        planet.add fleet
      end
      it 'should increase ship count' do
        planet.ship_count.should == 15
      end
      it 'still owned' do
        planet.player.should == :red
      end
    end
    
    describe "attack" do
      
      describe 'not enough' do
        let(:fleet) do
          Galcon::Fleet.new(:player => :blue, :ship_count => 5)
        end
        before do
          planet.add fleet
        end
        it 'should decrease ship count' do
          planet.ship_count.should == 5
        end
        it 'still owned' do
          planet.player.should == :red
        end
      end
      
      describe 'enough' do
        let(:fleet) do
          Galcon::Fleet.new(:player => :blue, :ship_count => 12)
        end
        before do
          planet.add fleet
        end
        it 'should change ship count' do
          planet.ship_count.should == 2
        end
        it 'changes owner' do
          planet.player.should == :blue
        end
      end
      
    end
  end
end
