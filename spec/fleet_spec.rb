require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Fleet" do
  let(:fleet) do
    Galcon::Fleet.new(:player => fleet_owner, :size => fleet_size, :loc => [0,0].to_cord)
  end
  let(:target) do
    Galcon::Planet.new(:loc => [3,0].to_cord, :ship_count => 20, :player => target_owner)
  end
  let(:target_owner) { :red }
  let(:fleet_size) { 10 }
  
  before do
    fleet.goto target
  end
  
  describe "reinforce" do
    let(:fleet_owner) { :red }
    describe "move once" do
      before do
        fleet.mission.advance!
      end
      it 'loc moves' do
        fleet.loc.x.should == 1
      end
      it 'doesnt add to planet' do
        target.ship_count.should == 20
      end
    end
  
    describe 'move till target reached' do
      before do
        3.times { fleet.mission.advance! }
      end
      it 'at target' do
        fleet.loc.x.should == 3
      end
      it 'at_target' do
        fleet.mission.should be_at_target
      end
      it 'adds to planet' do
        target.ship_count.should == 30
      end
    end
  end
  
  describe "attack" do
    let(:fleet_owner) { :blue }
  
    describe 'move till target reached' do
      before do
        3.times { fleet.mission.advance! }
      end
      it 'at target' do
        fleet.loc.x.should == 3
      end
      it 'at_target' do
        fleet.mission.should be_at_target
      end
      it 'adds to planet' do
        target.ship_count.should == 10
      end
    end
  end
  
  describe "attack that wins" do
    let(:fleet_owner) { :blue }
    let(:fleet_size) { 25 }
  
    describe 'move till target reached' do
      before do
        3.times { fleet.mission.advance! }
      end
      it 'at target' do
        fleet.loc.x.should == 3
      end
      it 'at_target' do
        fleet.mission.should be_at_target
      end
      it 'adds to planet' do
        target.ship_count.should == 5
      end
      it 'switches owner' do
        target.player.should == :blue
      end
    end
  end
  
  describe "attack vs neutral" do
    let(:fleet_owner) { :blue }
    let(:fleet_size) { 10 }
    let(:target_owner) { nil }
  
    describe 'move till target reached' do
      before do
        3.times { fleet.mission.advance! }
      end
      it 'at target' do
        fleet.loc.x.should == 3
      end
      it 'at_target' do
        fleet.mission.should be_at_target
      end
      it 'adds to planet' do
        target.ship_count.should == 10
      end
      it 'switches owner' do
        target.player.should be_nil
      end
    end
  end
  
  describe "attack that wins vs neutral" do
    let(:fleet_owner) { :blue }
    let(:fleet_size) { 25 }
    let(:target_owner) { nil }
  
    describe 'move till target reached' do
      before do
        3.times { fleet.mission.advance! }
      end
      it 'at target' do
        fleet.loc.x.should == 3
      end
      it 'at_target' do
        fleet.mission.should be_at_target
      end
      it 'adds to planet' do
        target.ship_count.should == 5
      end
      it 'switches owner' do
        target.player.should == :blue
      end
      
      it 'fails' do
        return_two.should == 2
      end
    end
  end
  
  
end
