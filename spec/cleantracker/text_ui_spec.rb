require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/text_ui"

describe Cleantracker::TextUi do

  let(:director) { mock(:director).as_null_object }
  let(:ui) { Cleantracker::TextUi.new(director) }

  it "can be instantiated" do
    ui.director.should be(director)
  end

  it "lists the usage" do
    director.should_receive(:chart_list).and_return(["chart1", "chart2"])
    message = ui.usage
    message.include?("cleantracker [options] chart").should == true
    message.include?("chart1").should == true
    message.include?("chart2").should == true
  end

  context "sample charts" do

    before do
      director.stub!(:chart_list).and_return %w[bar line]
    end

    it "parses args with just graph" do
      ui.parse! %w{-u micah bar}
      ui.chart.should == "bar"

      ui.parse! %w{-u micah line}
      ui.chart.should == "line"
    end

    it "knows invalid graphs" do
      ui.should_receive(:usage!).with("invalid chart: fooey")
      ui.parse! %w{fooey}
    end

    it "requires graphs" do
      ui.should_receive(:usage!).with("chart is required")
      ui.parse! %w{}
    end

    it "parsed username and cache" do
      ui.parse! %w{-u foo bar}
      ui.username.should == "foo"
      ui.use_cache.should == nil

      ui.parse! %w{-u micah -c bar}
      ui.username.should == "micah"
      ui.use_cache.should == true

      ui.parse! %w{--username=bill --cache bar}
      ui.username.should == "bill"
      ui.use_cache.should == true
    end

  end


end