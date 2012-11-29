require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Galcon" do
  it "game" do
    load "vol/dumb_player_test.rb"
    2.should == 2
  end
end
