require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Galcon" do
  let(:start) do
    Galcon::Planet.new(:player => :red, :ship_count => 30, :location => [0,0].to_cord)
  end
  let(:finish) do
    Galcon::Planet.new(:player => :red, :ship_count => 10, :location => [3,0].to_cord)
  end
  
  let(:fleet) do
    start.fleet_to(finish, 20)
  end
  
  before do
    fleet
  end
  
  it 'should remove from source' do
    start.ship_count.should == 10
  end
  it 'should start at source' do
    fleet.loc.eq?(start.loc).should == true
  end
  
  describe 'arrives' do
    before do
      3.times { fleet.mission.advance! }
    end
    it 'reinforces' do
      finish.ship_count.should == 30
    end
  end
end
