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

    def self.y_calculator(acc_multiplier, &formula)
      lambda do |acc, data|
        result = (acc * acc_multiplier)
        return result if data.nil?
        result + formula.call(data)
      end
    end

    def self.sum(data)
      data.inject(0) { |sum, value| sum + value }
    end

    CNT = y_calculator(0) { |d| sum(d) }
    ACC = y_calculator(1) { |d| sum(d) }
    ONE = lambda { 1 }

    def _collect_y_values(groups, labels, y_calc)
      y_values = {}
      acc = 0
      labels.each do |label|
        acc = y_calc.call(acc, groups[label])
        y_values[label] = acc
      end
      y_values
    end

    def _valuate_data(groups, valuator)
      valuations = {}
      groups.each_pair do |group, data|
        valued_data = data.map &valuator
        valuations[group] = valued_data
      end
      valuations
    end

    def report(data, options={})
      y_calc = options[:y_calc] || CNT
      valuator = options[:valuator] || ONE
      groups = group_by(data) { |d| d.created_at.strftime("%b-%Y") }
      labels = _collect_date_labels(groups)
      valued_groups = _valuate_data(groups, valuator)
      y_values = _collect_y_values(valued_groups, labels, y_calc)
      max = y_values.values.max

      {:x_labels => labels,
      :x_range => (0...(labels.count)),
      :y_range => (0..max),
      :data => [labels.map { |label| y_values[label] * 100 / max }]}
    end

  end
end