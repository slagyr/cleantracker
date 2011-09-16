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
      abbrs = codecasts.inject({}) do |cache, c|
        cache[c[:key]] = cc_abbreviate(c[:permalink])
        cache
      end
      data.each do |d|
        d[:codecast_abbr] = abbrs[d[:item_key]]
      end
    end

  end

end