require "date"
require 'fileutils'

module Cleantracker
  class Data

    DATA_FILE = "/tmp/cleantracker/data"

    def save(data)
      FileUtils.mkdir_p(File.dirname(DATA_FILE))
      File.open(DATA_FILE, "w") { |f| Marshal.dump(data, f) }
    end

    def load
      File.open(DATA_FILE, "r") { |f| Marshal.load(f) }
    end

    def cache?
      File.exists?(DATA_FILE)
    end

    def group_by(data, &hat)
      groups = {}
      data.each do |d|
        group = hat.call(d)
        if groups[group]
          groups[group] << d
        else
          groups[group] = [d]
        end
      end
      groups
    end

    def _collect_date_labels(groups)
      group_keys = groups.keys.sort { |a, b| DateTime.parse(a) <=> DateTime.parse(b) }
      date = DateTime.parse(group_keys.first)
      end_date = DateTime.parse(group_keys.last)
      labels = []
      while date <= end_date
        labels << date.strftime("%b-%Y")
        date = date >> 1
      end
      labels
    end

    def _collect_counts(groups, labels)
      counts = {}
      labels.each do |label|
        count = groups[label].nil? ? 0 : groups[label].size
        counts[label] = count
      end
      counts
    end

    def history_report_for(data)
      groups = group_by(data) { |d| d.created_at.strftime("%b-%Y") }
      labels = _collect_date_labels(groups)
      counts = _collect_counts(groups, labels)
      max = counts.values.max

      {:x_labels => labels,
      :x_range => (0...(labels.count)),
      :y_range => (0..max),
      :data => labels.map { |label| counts[label] * 100 / max }}
    end

  end
end