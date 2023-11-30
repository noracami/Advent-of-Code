# frozen_string_literal: true

require './utils'
require 'English'

class Solution
  include Utils

  attr_reader :maps, :use_sample, :search_space

  DAY = 'day15'

  def self.part1
    Solution.new('part1')
            .use_sample_file
            .load_input
            .parse
            .set_target_line
            .iterate_every_sensor
  end

  def self.part2
    Solution.new('part1')
            .use_sample_file
            .load_input
            .parse
            .set_search_space
            .then { |model| model.search_space.times { |i| break if model.scan_target_line(i).zero? } }
  end

  def initialize(scope = nil)
    @use_sample = false

    case scope
    when 'part1', 'part2'
      @sample = "./#{DAY}/#{scope}-sample.txt"
      @input = "./#{DAY}/#{scope}-input.txt"
    else
      raise 'accept one of <part1|part2>'
    end

    use_sample_file unless File.file?(@input)
  end

  def use_sample_file
    @input = @sample
    @use_sample = true
    self
  end

  def load_input
    @res = use_sample ? parse_input(@sample) : parse_input(@input)
    self
  end

  def parse
    @data = []
    @res.each do |line|
      line =~ /x=(?<s_x>.+), y=(?<s_y>.+):.+x=(?<b_x>.+), y=(?<b_y>.+)\z/
      @data << $LAST_MATCH_INFO.then do |match|
        { sensor: { x: match[:s_x].to_i, y: match[:s_y].to_i },
          beacon: { x: match[:b_x].to_i, y: match[:b_y].to_i } }
      end
    end
    self
  end

  def set_target_line
    @baseline = use_sample ? 10 : 2_000_000
    self
  end

  def set_search_space
    @search_space = use_sample ? 20 : 4_000_000
    self
  end

  def scan_target_line(baseline)
    @baseline = baseline
    # puts "no. #{baseline}"
    res = @data.map do |line|
      # calculate radius
      radius = (line[:sensor][:x] - line[:beacon][:x]).abs + (line[:sensor][:y] - line[:beacon][:y]).abs
      # calculate distance of Sensor and baseline
      distance_of_sensor_and_baseline = (line[:sensor][:y] - @baseline).abs

      next unless radius > distance_of_sensor_and_baseline

      left_point_x = line[:sensor][:x] - (radius - distance_of_sensor_and_baseline)
      right_point_x = line[:sensor][:x] + (radius - distance_of_sensor_and_baseline)

      { left_point_x:, right_point_x: }
    end
    .compact

    current_right_end = -Float::INFINITY

    res
      .sort_by { |line| line[:left_point_x] }
      .reduce(0) do |memo, line|
      # puts "memo: #{memo}, left: #{line[:left_point_x]}, right: #{line[:right_point_x]}"
      if current_right_end.infinite? == -1
        current_right_end = 0
        line[:right_point_x]
      elsif line[:left_point_x] > memo + 1
        break [baseline, memo + 1]
      else
        [line[:right_point_x], memo].max
      end
    end.then do |y, x|
      unless x.nil?
        puts _ = { x:, y: }
        puts _ = (x * 4_000_000) + y
        break 0
      end

      1
    end
  end

  def iterate_every_sensor
    res = @data.map do |line|
      # calculate radius
      radius = (line[:sensor][:x] - line[:beacon][:x]).abs + (line[:sensor][:y] - line[:beacon][:y]).abs
      # calculate distance of Sensor and baseline
      distance_of_sensor_and_baseline = (line[:sensor][:y] - @baseline).abs

      next unless radius > distance_of_sensor_and_baseline

      left_point_x = line[:sensor][:x] - (radius - distance_of_sensor_and_baseline)
      right_point_x = line[:sensor][:x] + (radius - distance_of_sensor_and_baseline)

      { left_point_x:, right_point_x: }
    end
    .compact

    current_right_end = -Float::INFINITY

    res
      .sort_by { |line| line[:left_point_x] }
      .each { |line| puts line }
      .reduce(0) do |memo, line|
        # print current_right_end
        # print "\t" unless current_right_end.infinite? == -1
        # print "\t"
        if line[:left_point_x] <= current_right_end
          if line[:right_point_x] <= current_right_end
            puts _ = { line:, current_right_end: }
            memo
          else
            diff = line[:right_point_x] - current_right_end
            current_right_end = line[:right_point_x]
            diff = 0 if diff.negative?

            puts "memo(#{memo}) + diff(#{diff})"
            memo + diff
          end
        else
          current_right_end = line[:right_point_x]
          puts "memo(#{memo}) + (line[:right_point_x](#{line[:right_point_x]}) - line[:left_point_x](#{line[:left_point_x]}))"
          memo + (line[:right_point_x] - line[:left_point_x])
        end
      end
      .then { |result| puts result }
  end

  def print_result
    puts @answer
    (@bottom_bound + 1).times do |row|
      (@left_bound..@right_bound).each { |column| print maps["#{column}, #{row}"] }
      puts row
    end
  end
end
