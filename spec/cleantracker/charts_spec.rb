require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/charts"

describe Cleantracker::Charts do

  it "builds foreground param" do
    subject.foreground.should == "chf=bg,s,1E1E1E"
  end

  it "builds axis labels param" do
    subject.axis_labels(:x_labels => %w{A B}, :y_labels => %w{1 2}).should == "chxl=0:|1|2|1:|A|B"
    subject.axis_labels(:x_labels => %w{A B}).should == "chxl=1:|A|B"
    subject.axis_labels(:y_labels => %w{A B}).should == "chxl=0:|A|B"
    subject.axis_labels().should == nil
  end

  it "builds axis ranges param" do
    subject.axis_ranges().should == nil
    subject.axis_ranges(:x_range => (0..123)).should == "chxr=1,0,123"
    subject.axis_ranges(:y_range => (2..42)).should == "chxr=0,2,42"
    subject.axis_ranges(:x_range => (0..123), :y_range => (2..42)).should == "chxr=0,2,42|1,0,123"
  end

  it "builds axis label styles" do
    subject.axis_label_styles.should == "chxs=0,CCCCCC,11.5,0,lt,CCCCCC|1,CCCCCC,11.5,0,lt,CCCCCC"
  end

  it "build axis ticks" do
    subject.axis_ticks.should == "chxt=y,x"
  end

  it "builds chart size param" do
    subject.chart_size().should == "chs=200x100"
    subject.chart_size(:width => 123, :height => 456).should == "chs=123x456"
  end

  it "builds the chart type" do
    subject.chart_type.should == "cht=lc"
  end

  it "build chart color param" do
    subject.chart_color.should == "chco=5FC9E2"
  end

  it "builds grid step param" do
    subject.grid_steps.should == "chg=10,20"
  end

  it "builds line styles param" do
    subject.line_styles.should == "chls=4"
  end

  it "builds fill markers params" do
    subject.fill_markers.should == "chm=B,5FC9E299,0,0,0"
  end

  it "build the data param" do
    subject.data(:data => [1, 2, 3, 4, 5]).should == "chd=t:1,2,3,4,5"
    subject.data(:data => [1.2, 3.4, 5.6, 7.8]).should == "chd=t:1.2,3.4,5.6,7.8"
  end

  it "builds a line chart url" do
    options = {:data => [1, 2, 3]}
    url = subject.line_url(options)
    url.include?("http://chart.apis.google.com/chart").should == true
    url.include?(subject.foreground(options)).should == true
    url.include?(subject.axis_label_styles(options)).should == true
    url.include?(subject.axis_ticks(options)).should == true
    url.include?(subject.chart_size(options)).should == true
    url.include?(subject.chart_type(options)).should == true
    url.include?(subject.chart_color(options)).should == true
    url.include?(subject.grid_steps(options)).should == true
    url.include?(subject.line_styles(options)).should == true
    url.include?(subject.fill_markers(options)).should == true
    url.include?(subject.data(options)).should == true
  end
end