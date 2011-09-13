module Production

  attr_accessor :director

  # Hook #1.  Called when the production is newly created, before any loading has been done.
  # This is a good place to require needed files and instantiate objects in the business layer.
  def production_opening
    $:.unshift File.expand_path(File.dirname(__FILE__) + "/lib")
    require File.expand_path(File.dirname(__FILE__) + "/gems/bundler/setup")
    require 'cleantracker/director'
  end

  # Hook #2.  Called after internal gems have been loaded and stages have been instantiated, yet before
  # any scenes have been opened.
  def production_loaded
    @director = Cleantracker::Director.new
  end

#  # Hook #3.  Called when the production, and all the scenes, have fully opened.
#  def production_opened
#  end
#
#  # Called when the production is about to be closed.
#  def production_closing
#  end
#
#  # Called when the production is fully closed.
#  def production_closed
#  end

end