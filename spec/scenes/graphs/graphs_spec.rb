require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Graphs" do

  uses_limelight :scene => "graphs", :hidden => true

  it "should have default text" do
    scene.children.size.should == 1
    root = scene.children[0]
    root.text.should == "This is the Graphs scene."
  end

end