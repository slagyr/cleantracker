require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Loading" do

  uses_limelight :scene => "loading", :hidden => true

  it "sets itself as the view on director" do
    production.director.should_receive(:loading_scene_ready)
    scene
  end

  it "starts with a body and load button" do
    scene.find(:body).should_not == nil
    scene.find(:fresh_load_button).should_not == nil
    scene.find(:cache_load_button).should == nil
    scene.find(:loading_output).should == nil
  end

  it "enables the cache button" do
    scene.enable_cache
    scene.find(:cache_load_button).should_not == nil
  end

  it "loads fresh data" do
    production.director.should_receive(:load_clean_data)
    scene.find(:fresh_load_button).mouse_clicked(nil)

    scene.find(:fresh_load_button).should == nil
    scene.find(:loading_output).should_not == nil
  end

  it "loads cached data" do
    scene.enable_cache
    production.director.should_receive(:use_cached_data)
    scene.find(:cache_load_button).mouse_clicked(nil)

    scene.find(:cache_load_button).should == nil
    scene.find(:loading_output).should_not == nil
  end

  it "updates log when new model load is started" do
    scene.open_log
    scene.starting_load("foo")
    scene.loading_output.text.should == "Loading foo "
    scene.dots.running?.should == true
  end

  it "updates log when load is finished" do
    scene.open_log
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