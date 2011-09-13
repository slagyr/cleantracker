require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/director"

describe Cleantracker::Director do

  let(:client) { mock(:client).as_null_object }
  let(:charts) { mock(:charts).as_null_object }
  let(:data) { mock(:data).as_null_object }
  let(:cache) { mock(:cache).as_null_object }
  let(:curl) { mock(:curl).as_null_object }
  let(:view) { mock(:view).as_null_object }
  let(:director) { Cleantracker::Director.new(:charts => charts, :data => data, :cache => cache, :curl => curl, :view => view) }

  it "uses pass params in constructor" do
    director.charts.should be(charts)
    director.data.should be(data)
  end

  it "loads viewer history chart" do
    cache.should_receive(:[]).with(:viewers).and_return(:cached_viewers)
    data.should_receive(:history_report).with(:cached_viewers).and_return(:data => [:fooey])
    charts.should_receive(:line_url).with(:data => [:fooey], :width => 600, :height => 500).and_return("http://some.url")
    curl.should_receive(:get).with("http://some.url").and_return("/path/to/new_image")
    view.should_receive(:display_chart).with("/path/to/new_image")

    director.load_viewer_history_chart(:width => 600, :height => 500)
  end

end