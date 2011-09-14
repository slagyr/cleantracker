require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Graphs" do

  uses_limelight :scene => "graphs", :hidden => true

  it "has needed props" do
    scene.find(:chart_list).should_not == nil
    scene.find(:chart_frame).should_not == nil
  end

  it "loads viewer history by default" do
    production.director.should_receive(:graph_scene_ready)
    scene
  end

  it "shows chart loading" do
    scene.chart_loading

    frame = scene.find(:chart_frame)
    frame.children.first.text.should == "Your graph is loading..."
  end

  it "displays a chart" do
    scene.display_chart("Some Title", "images/logo_and_tagline.png")

    frame = scene.find(:chart_frame)

    title = scene.find(:chart_title)
    title.text.should == "Some Title"
    title.parent.should == frame

    chart = scene.find(:chart)
    chart.image.should == "images/logo_and_tagline.png"
    chart.parent.should == frame
  end

end