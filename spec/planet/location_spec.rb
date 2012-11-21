require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Galcon" do
  describe 'Planet' do
    describe 'location' do
      let(:planet) do
        Galcon::Planet.new(:location => [0,0])
      end
      it 'smoke' do
        planet.should be
      end
    end
  end
end
