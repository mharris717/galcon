require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Planets" do
  let(:planets) do
    Galcon::Planets.new(:planets => raw_planets.clone.reverse)
  end
  let(:raw_planets) do
    res = []
    res << Galcon::Planet.new(:loc => [0,0].to_cord, :player => :red)
    res << Galcon::Planet.new(:loc => [3,0].to_cord, :player => :blue)
    res << Galcon::Planet.new(:loc => [4,0].to_cord)
    res << Galcon::Planet.new(:loc => [6,2].to_cord)
    
    res << Galcon::Planet.new(:loc => [5,0].to_cord, :player => :green)
    res << Galcon::Planet.new(:loc => [7,0].to_cord, :player => :green)
    res
  end
  let(:source) { raw_planets.first }
  
  describe 'closest' do
    it 'closest any' do
      planets.closest(source).should == raw_planets[1]
    end
  
    it 'closest unowned' do
      planets.closest(source, :player => nil).should == raw_planets[2]
    end
  
    it 'closest blue' do
      planets.closest(source, :player => :blue).should == raw_planets[1]
    end
    it 'closest green' do
      planets.closest(source, :player => :green).should == raw_planets[4]
    end
  
    it 'closest enemy' do
      planets.closest(source, :player => :enemy).should == raw_planets[1]
    end
    it 'closest enemy 2' do
      planets.closest(raw_planets[1], :player => :enemy).should == raw_planets[4]
    end
    it 'closest unknown by me' do
      planets.closest(raw_planets[1], :player => :not_mine).should == raw_planets[2]
    end
  end
  
  describe 'list' do
    it 'by player - red' do
      planets.list(:player => :red).should == raw_planets[0..0]
    end
    it 'by player - green' do
      planets.list(:player => :green).sort.should == raw_planets.select { |x| x.player == :green }.sort
    end
    it 'by player - unowned' do
      planets.list(:player => nil).tap { |x| x.size.should == 2 }.sort.should == raw_planets.select { |x| x.player == nil }.sort
    end
    
    it 'by player - enemy' do
      planets.list(:player => [:enemy, :red]).sort.size.should == raw_planets.select { |x| x.player && x.player != :red }.sort.size
      planets.list(:player => [:enemy, :red]).sort.should == raw_planets.select { |x| x.player && x.player != :red }.sort
    end
    it 'by player - not mine' do
      planets.list(:player => [:not_mine, :red]).sort.size.should == raw_planets.select { |x| x.player != :red }.sort.size
      planets.list(:player => [:not_mine, :red]).sort.should == raw_planets.select { |x| x.player != :red }.sort
    end
    
    it 'errors on bad player' do
      lambda { planets.list(:player => [:fancy, :red]) }.should raise_error(Galcon::Planets::UnknownPlayerTypeError)
    end
  end
  
end
