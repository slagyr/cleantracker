module Cleantracker

  class Director

    attr_accessor :charts
    attr_accessor :data
    attr_accessor :cache
    attr_accessor :curl
    attr_accessor :view

    def initialize(options={})
      @charts = options[:charts] || Charts.new
      @data = options[:data] || Data.new
      @cache = options[:cache] || {}
      @curl = options[:curl] || {}
      @view = options[:view] || {}
    end

    def load_viewer_history_chart(options={})
      viewers = cache[:viewers]
      puts "viewers: #{viewers}"
      puts "data: #{data}"
      report = data.history_report(viewers)
      puts "report: #{report}"
      url = charts.line_url(options.merge(report))
      path = curl.get(url)
      view.display_chart(path)
    end

  end

end