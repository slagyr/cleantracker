require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/data"
require 'cleandata/dot_hash'

describe Cleantracker::Data do

  let(:data) do
    [{:key => 1, :created_at => DateTime.new(2010, 1, 1), :amount => 3, :type => "A"}.dottable,
    {:key => 2, :created_at => DateTime.new(2010, 2, 2), :amount => 5, :type => "B"}.dottable,
    {:key => 3, :created_at => DateTime.new(2010, 3, 3), :amount => 7, :type => "A"}.dottable,
    {:key => 4, :created_at => DateTime.new(2010, 3, 4), :amount => 11, :type => "B"}.dottable,
    {:key => 5, :created_at => DateTime.new(2010, 1, 5), :amount => 13, :type => "A"}.dottable,
    {:key => 6, :created_at => DateTime.new(2011, 1, 6), :amount => 17, :type => "B"}.dottable]
  end

  it "can group by date" do
    result = subject.group_by(data) {|x| x.created_at.strftime("%b-%Y") }
    result.size.should == 4
    result["Jan-2010"].map(&:key).should == [1, 5]
    result["Jan-2011"].map(&:key).should == [6]
    result["Feb-2010"].map(&:key).should == [2]
    result["Mar-2010"].map(&:key).should == [3, 4]
  end

  it "can prepare new_per_month_report" do
    result = subject.report(data)
    result[:y_range].should == (0..2)
    result[:x_range].should == (0...13)
    result[:x_labels].should == %w{Jan-2010 Feb-2010 Mar-2010 Apr-2010 May-2010 Jun-2010 Jul-2010 Aug-2010 Sep-2010 Oct-2010 Nov-2010 Dec-2010 Jan-2011}
    result[:data].should == [[100,50,100,0,0,0,0,0,0,0,0,0,50]]
  end

  it "can prepare accumulation_per_month report" do
    result = subject.report(data, :y_calc => Cleantracker::Data::ACC)
    result[:y_range].should == (0..6)
    result[:x_range].should == (0...13)
    result[:x_labels].should == %w{Jan-2010 Feb-2010 Mar-2010 Apr-2010 May-2010 Jun-2010 Jul-2010 Aug-2010 Sep-2010 Oct-2010 Nov-2010 Dec-2010 Jan-2011}
    result[:data].should == [[33,50,83,83,83,83,83,83,83,83,83,83,100]]
  end

  it "can prepare count report using counting formula" do
    result = subject.report(data, :y_calc => Cleantracker::Data::CNT, :valuator => lambda{ |d| d[:amount] * 10 })
    result[:y_range].should == (0..180)
    result[:x_range].should == (0...13)
    result[:x_labels].should == %w{Jan-2010 Feb-2010 Mar-2010 Apr-2010 May-2010 Jun-2010 Jul-2010 Aug-2010 Sep-2010 Oct-2010 Nov-2010 Dec-2010 Jan-2011}
    result[:data].should == [[88, 27, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 94]]
  end

  it "can prepare count report using accumulating formula" do
    result = subject.report(data, :y_calc => Cleantracker::Data::ACC, :valuator => lambda{ |d| d[:amount] * 10 })
    result[:y_range].should == (0..560)
    result[:x_range].should == (0...13)
    result[:x_labels].should == %w{Jan-2010 Feb-2010 Mar-2010 Apr-2010 May-2010 Jun-2010 Jul-2010 Aug-2010 Sep-2010 Oct-2010 Nov-2010 Dec-2010 Jan-2011}
    result[:data].should == [[28, 37, 69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 100]]
  end

  it "can report count with split data" do
    result = subject.report(data, :split => :type)
    result[:y_range].should == (0..2)
    result[:x_range].should == (0...13)
    result[:x_labels].should == %w{Jan-2010 Feb-2010 Mar-2010 Apr-2010 May-2010 Jun-2010 Jul-2010 Aug-2010 Sep-2010 Oct-2010 Nov-2010 Dec-2010 Jan-2011}
    result[:data].should == [[100,0,50,0,0,0,0,0,0,0,0,0,0],[0,50,50,0,0,0,0,0,0,0,0,0,50]]
    result[:data_labels].should == ["A", "B"]
  end

end
