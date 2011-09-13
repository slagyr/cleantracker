require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "cleantracker/curl"

describe Cleantracker::Curl do

  it "generates random filenames" do
    names = []
    100.times { names << subject.new_name }
    names.uniq.size.should == 100
  end

  it "gets stuff" do
    path = subject.get("http://www.8thlight.com/images/logos/8L-logo.png")
    File.exists?(path).should == true
  end

end
