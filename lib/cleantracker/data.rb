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
    YEAR_MONTH = lambda { |d| d.created_at.strftime("%b-%Y") }

    def _to_lambda(grouper, default)
      grouper ||= default
      if grouper.is_a?(Symbol)
        lambda { |d| d[grouper] }
      else
        grouper
      end
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

    def _group_data(data, grouper)
      grouper = _to_lambda(grouper, YEAR_MONTH)
      group_by(data, &grouper)
    end

    def _split_data(groups, split)
      return {:default => groups} if split.nil?
      splitter = lambda { |d| d[split] }
      splits = {}
      groups.each_pair do |group, dataset|
        tmp_splits = group_by(dataset, &splitter)
        tmp_splits.each_pair do |split_label, subset|
          splits[split_label] ||= {}
          splits[split_label][group] = subset
        end
      end
      splits
    end

    def _date_labels(groups)
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

    def _collect_labels(groups, grouper)
      if grouper.nil?
        _date_labels(groups)
      else
        groups.keys.sort
      end
    end

    def _sort_data(split_labels, group_labels, splits)
      split_labels.map do |split|
        groups = splits[split]
        group_labels.map { |label| groups[label] || [] }
      end
    end

    def _reduce_y_values(datasets, y_calc)
      y_calc ||= CNT
      datasets.map do |subsets|
        acc = 0
        subsets.map do |data|
          acc = y_calc.call(acc, data)
        end
      end
    end

    def _valuate_data(datasets, valuator)
      valuator = _to_lambda(valuator, ONE)
      datasets.map do |subsets|
        subsets.map do |data|
          data.nil? ? [] : (data.map &valuator)
        end
      end
    end

    def _calculate_max(reduced_values)
      sums = []
      reduced_values.first.size.times do |i|
        sums << reduced_values.inject(0) { |sum, set| sum + set[i] }
      end

      sums.max
    end

    def _calculate_percentages(max, reduced_values)
      reduced_values.map do |subset|
        subset.map { |v| v * 100 / max }
      end
    end

    def report(data, options={})
      groups = _group_data(data, options[:grouper])
      splits = _split_data(groups, options[:split])

      group_labels = _collect_labels(groups, options[:grouper])
      split_labels = splits.keys.sort

      sorted_data = _sort_data(split_labels, group_labels, splits)
      valued_data = _valuate_data(sorted_data, options[:valuator])
      reduced_values = _reduce_y_values(valued_data, options[:y_calc])

      max = _calculate_max(reduced_values)
      percentages = _calculate_percentages(max, reduced_values)

      {:x_labels => group_labels,
       :x_range => (0...(group_labels.count)),
       :y_range => (0..max),
       :data => percentages,
       :data_labels => options[:split] ? split_labels : nil}
    end

  end
end