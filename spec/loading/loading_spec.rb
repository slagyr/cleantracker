require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Loading" do

  uses_limelight :scene => "loading", :hidden => true

  before do
    @client = mock("Cleandata::Client").as_null_object
    production.production_opening
    production.cleandata = @client
  end

  it "loads stuff when the scene is opened" do
    @client.should_receive(:viewers)
    @client.should_receive(:codecasts)
    @client.should_receive(:licenses)
    @client.should_receive(:payments)
    @client.should_receive(:viewings)
    @client.should_receive(:downloads)

    scene # calls scene_opened

    output = scene.loading_output.text
    output.include?("Loading viewers").should == true
    output.include?("Loading codecasts").should == true
    output.include?("Loading licenses").should == true
    output.include?("Loading payments").should == true
    output.include?("Loading viewings").should == true
    output.include?("Loading downloads").should == true
  end

  it "loaded data stored in production" do
    @client.should_receive(:viewers).and_return(:VIEWERS)
    @client.should_receive(:codecasts).and_return(:CODECASTS)
    @client.should_receive(:licenses).and_return(:LICENSES)
    @client.should_receive(:payments).and_return(:PAYMENTS)
    @client.should_receive(:viewings).and_return(:VIEWINGS)
    @client.should_receive(:downloads).and_return(:DOWNLOADS)

    scene # calls scene_opened

    production.cache[:viewers].should == :VIEWERS
    production.cache[:codecasts].should == :CODECASTS
    production.cache[:licenses].should == :LICENSES
    production.cache[:payments].should == :PAYMENTS
    production.cache[:viewings].should == :VIEWINGS
    production.cache[:downloads].should == :DOWNLOADS
  end

  #it "loads the graphs scene when done loading" do
  #  producer.should_receive(:open_scene).with("loading", anything)
  #  producer.should_receive(:open_scene).with("graphs", production.theater["default"])
  #
  #  scene
  #end

end