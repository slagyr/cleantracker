require 'cleandata/client'

module Cleantracker

  class Director

    attr_accessor :charts
    attr_accessor :data
    attr_accessor :cache
    attr_accessor :curl
    attr_accessor :view
    attr_accessor :client

    def initialize(options={})
      @charts = options[:charts] || Charts.new
      @data = options[:data] || Data.new
      @cache = options[:cache] || {}
      @curl = options[:curl] || {}
      @view = options[:view] || {}
    end

    def login(options)
      #client = Cleandata::Client.new(options.merge(:host => "localhost", :port => 8080))
      @client = Cleandata::Client.new(options)
      begin
        @client.connection
        view.login_succeeded
      rescue Exception => e
        view.login_failed(e.message)
      end
    end

    def load_clean_data
      begin
        %w{viewers codecasts licenses payments viewings downloads}.each do |model|
          load_data(model)
        end
        view.all_models_loaded
      rescue Exception => e
        puts e
        puts e.backtrace
        view.log e
        view.log e.backtrace.join("\n")
      end
    end


    def load_viewer_history_chart(options={})
      viewers = cache[:viewers]
      report = data.history_report(viewers)
      url = charts.line_url(options.merge(report))
      path = curl.get(url)
      view.display_chart("Viewer History", path)
    end

    private

    def load_data(model)
      begin
        view.starting_load(model)
        @cache[model.to_sym] = @client.send(model.to_sym)
      ensure
        view.finished_load
      end
    end

  end

end