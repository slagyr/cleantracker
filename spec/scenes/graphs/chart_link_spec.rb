require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Chart Links" do

  uses_limelight :scene => "graphs", :hidden => true

  before do
    scene #get scene loading out of the way
  end

  it "has plenty of chart links" do
    links = scene.find_by_name("chart_link")
    links.size.should > 3
  end

  it "triggers a load on click" do
    production.director.should_receive(:load_chart).with("new_viewers_per_month", anything)
    scene.find("new_viewers_per_month").mouse_clicked(nil)
  end

end