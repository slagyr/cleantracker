require 'rubygems'
require 'rspec'

$:.unshift File.expand_path(File.dirname(__FILE__) + "/../lib")

RSpec.configure do |config|
  config.after(:suite) do
    Java::java.awt.Window.getWindows.each do |window|
      window.dispose
    end
  end
end