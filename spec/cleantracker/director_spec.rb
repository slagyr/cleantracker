require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/director"

describe Cleantracker::Director do

  let(:client) { mock(:client).as_null_object }
  let(:connection) { mock(:connection).as_null_object }
  let(:charts) { mock(:charts).as_null_object }
  let(:data) { mock(:data).as_null_object }
  let(:cache) { {} }
  let(:curl) { mock(:curl).as_null_object }
  let(:view) { mock(:view).as_null_object }
  let(:director) { Cleantracker::Director.new(:charts => charts, :data => data, :cache => cache, :curl => curl, :view => view) }

  it "uses pass params in constructor" do
    director.charts.should be(charts)
    director.data.should be(data)
  end

  it "failed login" do
    Cleandata::Client.should_receive(:new).with(:username => "blah", :password => "blah").and_return(client)
    client.should_receive(:connection).and_raise("Nope!")
    view.should_receive(:login_failed).with("Nope!")

    director.login(:username => "blah", :password => "blah")
  end

  it "successful login" do
    Cleandata::Client.should_receive(:new).with(:username => "blah", :password => "blah").and_return(client)
    client.should_receive(:connection).and_return(connection)
    view.should_receive(:login_succeeded)

    director.login(:username => "blah", :password => "blah")
  end

  it "loads models" do
    director.client = client
    client.should_receive(:viewers)
    client.should_receive(:codecasts)
    client.should_receive(:licenses)
    client.should_receive(:payments)
    client.should_receive(:viewings)
    client.should_receive(:downloads)

    director.load_clean_data

    director.cache.has_key?(:viewers).should == true
    director.cache.has_key?(:codecasts).should == true
    director.cache.has_key?(:licenses).should == true
    director.cache.has_key?(:payments).should == true
    director.cache.has_key?(:viewings).should == true
    director.cache.has_key?(:downloads).should == true
  end

  it "informs view of loading" do
    director.client = client

    %w{viewers codecasts licenses payments viewings downloads}.each do |model|
      view.should_receive(:starting_load).with(model)
    end
    view.should_receive(:finished_load).exactly(6).times
    view.should_receive(:all_models_loaded).once

    director.load_clean_data
  end

  it "loads viewer history chart" do
    cache.should_receive(:[]).with(:viewers).and_return(:cached_viewers)
    data.should_receive(:history_report_for).with(:cached_viewers).and_return(:data => [:fooey])
    charts.should_receive(:line_url).with(:data => [:fooey], :width => 600, :height => 500).and_return("http://some.url")
    curl.should_receive(:get).with("http://some.url").and_return("/path/to/new_image")
    view.should_receive(:display_chart).with("Viewer History", "/path/to/new_image")

    director.load_viewer_history_chart(:width => 600, :height => 500)
  end

end