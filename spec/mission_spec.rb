require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Mission" do
  it "smoke" do
    s = Galcon::Mission.new.to_s
    s.should be
  end
end
