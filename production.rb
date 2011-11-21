module Production

  attr_accessor :director

  def production_opening
    $:.unshift File.expand_path(File.dirname(__FILE__) + "/lib")
    require File.expand_path(File.dirname(__FILE__) + "/gems/bundler/setup")
    require 'cleananalytics/director'
    require 'cleandata/client'
  end

  def production_loaded
    client = Cleandata::Client.new
    @director = Cleantracker::Director.new(:client => client)
  end

end