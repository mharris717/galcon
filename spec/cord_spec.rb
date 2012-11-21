require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Galcon" do
  let(:start) do
    [2,1].to_cord
  end
  let(:finish) do
    [5,7].to_cord
  end
  
  it 'to_s' do
    start.to_s.should == '2,1'
  end
  
  it 'distance' do
    exp = (9 + 36)**0.5
    start.dist(finish).should == exp
  end
end
