require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Loading" do

  uses_limelight :scene => "loading", :hidden => true

  it "sets itself as the view on director" do
    production.director.should_receive(:view=)
    scene
  end

  it "initiates loading when opened" do
    production.director.should_receive(:load_clean_data)
    scene
  end

  it "updates log when new model load is started" do
    scene.starting_load("foo")
    scene.loading_output.text.should == "Loading foo "
    scene.dots.running?.should == true
  end

  it "updates log when load is finished" do
    scene.starting_load("foo")
    scene.finished_load
    scene.loading_output.text.should == "Loading foo DONE\n"
    scene.dots.running?.should == false
  end

  it "loads the graphs scene when done loading" do
    scene # get initial loading out of the way

    producer.should_receive(:open_scene).with("graphs", production.theater["default"])

    scene.all_models_loaded
  end

end