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

  it "prepares login scene" do
    director.view = nil

    director.login_scene_ready(view)
    director.view.should == view
  end
  #
  #it "failed login" do
  #  Cleandata::Client.should_receive(:new).with(:username => "blah", :password => "blah").and_return(client)
  #  client.should_receive(:connection).and_raise("Nope!")
  #  view.should_receive(:login_failed).with("Nope!")
  #
  #  director.login(:username => "blah", :password => "blah")
  #end
  #
  #it "successful login" do
  #  Cleandata::Client.should_receive(:new).with(:username => "blah", :password => "blah").and_return(client)
  #  client.should_receive(:connection).and_return(connection)
  #  view.should_receive(:login_succeeded)
  #
  #  director.login(:username => "blah", :password => "blah")
  #end

  it "prepares loading scene with no cached data" do
    director.view = nil
    data.should_receive(:cache?).and_return(false)
    view.should_not_receive(:enable_cache)

    director.loading_scene_ready(view)

    director.view.should == view
  end

  it "loads models" do
    director.client = client
    client.should_receive(:viewers)
    client.should_receive(:codecasts)
    client.should_receive(:licenses)
    client.should_receive(:payments)
    client.should_receive(:viewings)
    client.should_receive(:downloads)
    data.should_receive(:save).with(cache)

    director.load_clean_data

    cache.has_key?(:viewers).should == true
    cache.has_key?(:codecasts).should == true
    cache.has_key?(:licenses).should == true
    cache.has_key?(:payments).should == true
    cache.has_key?(:viewings).should == true
    cache.has_key?(:downloads).should == true
  end

  it "uses cached data" do
    data.should_receive(:load)
    view.should_receive(:all_models_loaded).once

    director.use_cached_data
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

  it "prepare chart scene" do
    director.view = nil
    director.should_receive(:load_chart).with(:viewer_accumulation, {:default => :options})

    director.graph_scene_ready(view, {:default => :options})

    director.view.should == view
  end

  it "loads new viewers/month chart" do
    view.should_receive(:chart_loading)
    cache[:viewers] = :cached_viewers
    data.should_receive(:report) do |data, options|
      data.should == :cached_viewers
      options[:y_calc].should == Cleantracker::Data::CNT
      {:data => [:fooey]}
    end
    charts.should_receive(:build_url) do |kind, options|
      kind.should == :bar
      options[:data].should == [:fooey]
      options[:width].should == 600
      options[:height].should == 500
      "http://some.url"
    end
    curl.should_receive(:get).with("http://some.url").and_return("/path/to/new_image")
    view.should_receive(:display_chart).with("New Viewers/Month", "/path/to/new_image")

    director.load_chart(:new_viewers_per_month, :width => 600, :height => 500)
    director.cache[:charts]["New Viewers/Month"].should_not == nil
  end

  it "caches images" do
    director.cache[:charts] = {"New Viewers/Month" =>  "/some/path"}

    view.should_not_receive(:chart_loading)
    data.should_not_receive(:new_per_month_report)
    view.should_receive(:display_chart).with("New Viewers/Month", "/some/path")

    director.load_chart(:new_viewers_per_month, :width => 600, :height => 500)
  end

  it "loads viewer accumulation chart" do
    view.should_receive(:chart_loading)
    cache[:viewers] = :cached_viewers
    data.should_receive(:report) do |data, options|
      data.should == :cached_viewers
      options[:y_calc].should == Cleantracker::Data::ACC
      {:data => [:fooey]}
    end
    charts.should_receive(:build_url) do |kind, options|
      kind.should == :line
      options[:data].should == [:fooey]
      options[:width].should == 600
      options[:height].should == 500
      "http://some.url"
    end
    curl.should_receive(:get).with("http://some.url").and_return("/path/to/new_image")
    view.should_receive(:display_chart).with("Viewer Accumulation", "/path/to/new_image")

    director.load_chart(:viewer_accumulation, :width => 600, :height => 500)
    director.cache[:charts]["Viewer Accumulation"].should_not == nil
  end

end