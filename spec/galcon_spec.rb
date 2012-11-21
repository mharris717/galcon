require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Galcon" do
  it "smoke" do
    Galcon::Planet.should be
    2.should == 2
  end
end
