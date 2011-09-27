require 'cleandata/client'
require 'cleananalytics/director'
require 'optparse'
require 'java'

module Cleantracker

  class TextUi

    def self.run(args)
      client = Cleandata::Client.new
      director = Cleantracker::Director.new(:client => client)
      ui = TextUi.new(director)
      ui.main(args)
    end

    attr_reader :director
    attr_reader :chart
    attr_reader :username
    attr_reader :use_cache

    def initialize(director)
      @director = director
    end

    def parse!(args)
      parser.parse!(args)
      @chart = args.shift
      raise "chart is required" unless @chart
      raise "invalid chart: #{@chart}" unless director.chart_list.include?(@chart)
      raise "username is required" unless @username
    rescue Exception => e
      usage!(e.message)
    end

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = "Usage: cleantracker [options] chart"
        opts.on("-h", "--help", "Print help") { puts usage! }
        opts.on("-u", "--username USERNAME", "Cleancoders Username") { |name| @username = name }
        opts.on("-c", "--cache", "Use cached data if available") { |name| @use_cache = true }
      end
      @parser
    end

    def usage
      output = parser.help
      output << "    charts:\n"
      @director.chart_list.each do |chart|
        output << "      " << chart << "\n"
      end
      output
    end

    def usage!(message = nil)
      puts message if message
      puts usage
      exit message.nil? ? 0 : -1
    end

    def get_password
      password_chars = java.lang.System.console.readPassword("Password: ")
      java.lang.String.new(password_chars)
    end

    def main(args)
      parse!(args)
      @password = get_password
      director.login_scene_ready(self)
      director.login(:username => @username, :password => @password)
      director.loading_scene_ready(self)
      puts "@cache_enabled: #{@cache_enabled}"
      puts "@use_cache: #{@use_cache}"
      if @cache_enabled && @use_cache
        director.use_cached_data
      else
        director.load_clean_data
      end
    rescue Exception => e
      puts e
      puts e.backtrace
    end

    def log(message)
      puts message
    end

    def login_succeeded
      puts "login successful"
    end

    def login_failed(message)
      puts "!!! Login FAILED"
    end

    def enable_cache
      @cache_enabled = true
    end

    def all_models_loaded
      @director.load_chart(@chart, :width => 600, :height => 375)
    end

    def starting_load(model)
      print "Loading #{model}..."
    end

    def finished_load
      puts "DONE"
    end

    def chart_loading
      puts "loading chart..."
    end

    def display_chart(title, path)
      puts "Chart Title: #{title}"
      system "open #{path}"
    end
  end

end