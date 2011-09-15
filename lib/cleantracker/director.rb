require 'cleandata/client'
require 'cleantracker/charts'
require 'cleantracker/data'
require 'cleantracker/curl'

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
      @curl = options[:curl] || Curl.new
      @view = options[:view]
    end

    def login_scene_ready(view)
      @view = view
    end

    def login(options)
      @client = Cleandata::Client.new(options.merge(:host => "localhost", :port => 8080))
      #@client = Cleandata::Client.new(options)
      begin
        @client.connection
        view.login_succeeded
      rescue Exception => e
        view.login_failed(e.message)
      end
    end

    def loading_scene_ready(view)
      @view = view
      if @data.cache?
        view.enable_cache
      end
    end

    def use_cached_data
      @view.log("Loading cached data...")
      @cache = @data.load
      @view.all_models_loaded
    end

    def graph_scene_ready(view, options)
      @view = view
      load_chart(:viewer_accumulation, options)
    end

    def load_clean_data
      begin
        %w{viewers codecasts licenses payments viewings downloads}.each do |model|
          load_data(model)
        end
        @data.save(@cache)
        @view.log("Saving data")
        @view.all_models_loaded
      rescue Exception => e
        puts e
        puts e.backtrace
        @view.log e
        @view.log e.backtrace.join("\n")
      end
    end

    BAR = {:y_calc => Data::CNT, :chart_kind => :bar, :valuator => Data::ONE}
    LINE = {:y_calc => Data::ACC, :chart_kind => :line, :valuator => Data::ONE}
    CHARTS = {
      :new_viewers_per_month => BAR.merge(:model => :viewers, :title => "New Viewers/Month"),
      :new_codecasts_per_month => BAR.merge(:model => :codecasts, :title => "New Codecasts/Month"),
      :new_licenses_per_month => BAR.merge(:model => :licenses, :title => "New Licenses/Month", :chart_kind => :stacked_bar, :split => :level, :valuator => lambda { |l| l[:quantity] }),
      :new_viewings_per_month => BAR.merge(:model => :viewings, :title => "New Viewings/Month"),
      :new_downloads_per_month => BAR.merge(:model => :downloads, :title => "New Download/Month"),
      :viewer_accumulation => LINE.merge(:model => :viewers, :title => "Viewer Accumulation"),
      :license_accumulation => LINE.merge(:model => :licenses, :title => "License Accumulation", :valuator => lambda { |l| l[:quantity] }),
      :viewing_accumulation => LINE.merge(:model => :viewings, :title => "Viewing Accumulation"),
      :download_accumulation => LINE.merge(:model => :downloads, :title => "Download Accumulation"),
      :revenue_per_month => BAR.merge(:model => :payments, :title => "$ Revenue/Month", :valuator => lambda{ |p| (p[:amount] || 0)/100.0 }),
      :revenue_accumulation => LINE.merge(:model => :payments, :title => "$ Revenue Accumlation", :valuator => lambda{ |p| (p[:amount] || 0)/100.0 })
    }

    def load_chart(name, options={})
      chart_options = CHARTS[name.to_sym]
      raise "Missing chart #{name}" if chart_options.nil?
      _load_chart(chart_options.merge(options))
    end

    private

    def load_data(model)
      begin
        @view.starting_load(model)
        @cache[model.to_sym] = @client.send(model.to_sym)
      ensure
        @view.finished_load
      end
    end

    def _with_chart_caching(key)
      @cache[:charts] ||= {}
      path = @cache[:charts][key]
      if path.nil?
        path = yield
        @cache[:charts][key] = path
      end
      path
    end

    def _load_chart(options)
      path = _with_chart_caching(options[:title]) do
        @view.chart_loading
        models = @cache[options[:model]]
        report = @data.report(models, options)
        p report
        url = @charts.build_url(options[:chart_kind], options.merge(report))
        @curl.get(url)
      end
      @view.display_chart(options[:title], path)
    end

  end

end