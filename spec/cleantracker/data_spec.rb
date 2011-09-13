require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/data"
require 'cleandata/dot_hash'

describe Cleantracker::Data do

  let(:data) do
    [{:key => 1, :created_at => DateTime.new(2010, 1, 1)}.dottable,
    {:key => 2, :created_at => DateTime.new(2010, 2, 2)}.dottable,
    {:key => 3, :created_at => DateTime.new(2010, 3, 3)}.dottable,
    {:key => 4, :created_at => DateTime.new(2010, 3, 4)}.dottable,
    {:key => 5, :created_at => DateTime.new(2010, 1, 5)}.dottable,
    {:key => 6, :created_at => DateTime.new(2011, 1, 6)}.dottable]
  end

  it "can group by date" do
    result = subject.group_by(data) {|x| x.created_at.strftime("%b-%Y") }
    result.size.should == 4
    result["Jan-2010"].map(&:key).should == [1, 5]
    result["Jan-2011"].map(&:key).should == [6]
    result["Feb-2010"].map(&:key).should == [2]
    result["Mar-2010"].map(&:key).should == [3, 4]
  end

  it "can prepare history report" do
    result = subject.history_report_for(data)
    result[:y_range].should == (0..2)
    result[:x_range].should == (0...13)
    result[:x_labels].should == %w{Jan-2010 Feb-2010 Mar-2010 Apr-2010 May-2010 Jun-2010 Jul-2010 Aug-2010 Sep-2010 Oct-2010 Nov-2010 Dec-2010 Jan-2011}
    result[:data].should == [100,50,100,0,0,0,0,0,0,0,0,0,50]
  end

end