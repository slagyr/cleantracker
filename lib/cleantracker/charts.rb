module Cleantracker
  class Charts

    PARAMS = [:foreground, :axis_ranges, :axis_labels, :axis_label_styles,
              :axis_ticks, :chart_size, :chart_type, :chart_color,
              :grid_steps, :line_styles, :fill_markers, :bar_width_spacing,
              :data_labels, :legend_location, :legend_style, :data]

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
      case options[:kind]
        when :line; "cht=lc"
        when :bar; "cht=bvg"
        when :stacked_bar; "cht=bvs"
        else "cht=lc"
      end

    end

    def _data_count(options)
      options[:data] ? options[:data].size : 1
    end

    COLORS = %w{5FC9E2 A62315 149931 A67915}
    def chart_color(options={})
      n = _data_count(options)
      colors = COLORS[0...n]
      "chco=#{colors.join(",")}"
    end

    def grid_steps(options={})
      "chg=10,20,0,0"
    end

    def line_styles(options={})
      "chls=4"
    end

    def fill_markers(options={})
      if options[:kind] == :line
        "chm=B,5FC9E299,0,0,0"
      else
        nil
      end
    end

    def bar_width_spacing(options={})
      if [:bar, :stacked_bar].include?(options[:kind])
        "chbh=a,4,20"
      else
        nil
      end
    end

    def data_labels(options={})
      if options[:data_labels]
        "chdl=#{options[:data_labels].join("|")}"
      else
        nil
      end
    end

    def legend_location(options={})
      "chdlp=b"
    end

    def legend_style(options={})
      "chdls=CCCCCC,12"
    end

    def data(options={})
      data_as_values = options[:data].map { |d| d.join(",") }
      "chd=t:#{data_as_values.join("|")}"
    end

    def build_url(kind, options)
      options[:kind] = kind
      params = PARAMS.map { |p| self.send(p, options) }
      params.reject! { |p| p.nil? }
      "http://chart.apis.google.com/chart?#{params.join("&")}"
    end

    def line_url(options={})
      build_url(:line, options)
    end

    def bar_url(options={})
      build_url(:bar, options)
    end

  end
end
