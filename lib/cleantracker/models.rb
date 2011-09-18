module Cleantracker

  class Models

    def cc_abbreviate(name)
      case name
        when /episode-(\d+)-sc-(\d+)/
          "SC#{$1}-#{$2}"
        when /episode-(\d+)-part-(\d+)/
          "E#{$1}-#{$2}"
        when /episode-(\d+)/
          "E#{$1}"
        else
          name[0..0] + name[1..-1].gsub(/[a-z]/, "")
      end
    end

    def add_codecast_abbreviations(codecasts, data)
      return if data.first.has_key?(:codecast_abbr)
      add_abbreviations(codecasts)

      abbrs = codecasts.inject({}) do |cache, c|
        cache[c[:key]] = c[:abbr]
        cache
      end

      data.each do |d|
        d[:codecast_abbr] = abbrs[d[:item_key]]
      end
    end

    def add_abbreviations(codecasts)
      return if codecasts.first.has_key?(:abbr)
      codecasts.each do |c|
        c[:abbr] = cc_abbreviate(c[:permalink])
      end
    end

  end

end