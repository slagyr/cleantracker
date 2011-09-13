module Cleantracker
  class Charts

    PARAMS = [:foreground, :axis_ranges, :axis_labels, :axis_label_styles,
              :axis_ticks, :chart_size, :chart_type, :chart_color,
              :grid_steps, :line_styles, :fill_markers, :data]

    def foreground(options={})
      "chf=bg,s,1E1E1E"
    end

    def axis_labels(options={})
      labels = []
      labels << "0:|" + options[:y_labels].join("|") if options[:y_labels]
      labels << "1:|" + options[:x_labels].join("|") if options[:x_labels]
      labels.empty? ? nil : ("chxl=" + labels.join("|"))
    end

    def axis_ranges(options={})
      labels = []
      labels << "0,#{options[:y_range].min},#{options[:y_range].max}" if options[:y_range]
      labels << "1,#{options[:x_range].min},#{options[:x_range].max}" if options[:x_range]
      labels.empty? ? nil : ("chxr=" + labels.join("|"))
    end

    def axis_label_styles(options={})
      "chxs=0,CCCCCC,11.5,0,lt,CCCCCC|1,CCCCCC,11.5,0,lt,CCCCCC"
    end

    def axis_ticks(options={})
      "chxt=y,x"
    end

    def chart_size(options={})
      "chs=#{options[:width] || 200}x#{options[:height] || 100}"
    end

    def chart_type(options={})
      "cht=lc"
    end

    def chart_color(options={})
      "chco=5FC9E2"
    end

    def grid_steps(options={})
      "chg=10,20,0,0"
    end

    def line_styles(options={})
      "chls=4"
    end

    def fill_markers(options={})
      "chm=B,5FC9E299,0,0,0"
    end

    def data(options={})
      "chd=t:#{options[:data].join(",")}"
    end

    def line_url(options={})
      params = PARAMS.map { |p| self.send(p, options) }
      params.reject! { |p| p.nil? }
      "http://chart.apis.google.com/chart?#{params.join("&")}"
    end

  end
end
