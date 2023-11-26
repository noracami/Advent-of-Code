# frozen_string_literal: true

require './utils'
require 'English'

class Solution
  include Utils

  attr_reader :maps, :use_sample

  DAY = 'day15'
  SAND_SPAWN_POINT = [500, 0].freeze

  def self.part1
    Solution.new('part1')
            .use_sample_file
            .load_input
            .parse
            .set_target_line
            .iterate_every_sensor
    # .print_result
  end

  # def self.part2
  #   Solution.new('part2')
  #           # .use_sample_file
  #           .load_input
  #           .build_maps
  #           .build_rocks
  #           .set_boundary_two
  #           .simulate_sand_falling_two
  #           .print_result
  # end

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

  def iterate_every_sensor
    @data.each do |line|
      # calculate radius
      radius = (line[:sensor][:x] - line[:beacon][:x]).abs + (line[:sensor][:y] - line[:beacon][:y]).abs
      # calculate distance of Sensor and baseline
      distance_of_sensor_and_baseline = (line[:sensor][:y] - @baseline).abs

      # puts "radius: #{radius},\t \
      #       D: #{distance_of_sensor_and_baseline},\t \
      #       intersected?: #{radius > distance_of_sensor_and_baseline}"

      next unless radius > distance_of_sensor_and_baseline

      left_point_x = line[:sensor][:x] - (radius - distance_of_sensor_and_baseline)
      right_point_x = line[:sensor][:x] + (radius - distance_of_sensor_and_baseline)
      puts _ = { left_point_x:, right_point_x: }
    end
  end

  # def set_maps_with_coordinate(value, coordinate = [])
  #   raise 'invalid coordinate' if coordinate.size != 2

  #   maps[coordinate.map(&:to_s).join(', ')] = value
  # end

  # def maps_with_coordinate(coordinate = [])
  #   raise 'invalid coordinate' if coordinate.size != 2

  #   maps[coordinate.map(&:to_s).join(', ')]
  # end

  # def build_maps
  #   @maps = {}
  #   165.times do |row|
  #     (300..702).each do |column|
  #       set_maps_with_coordinate('.', [column, row])
  #     end
  #   end
  #   set_maps_with_coordinate('+', SAND_SPAWN_POINT)
  #   self
  # end

  # def build_rocks
  #   @res
  #     .map { |line| line.split(' -> ').map { |el| el.split(',').map(&:to_i) } }
  #     .each do |line|
  #     line.each_cons(2) do |prev, nxt|
  #       if prev[0] == nxt[0]
  #         rows = prev[1] >= nxt[1] ? nxt[1]..prev[1] : prev[1]..nxt[1]
  #         rows.each { |row| maps["#{prev[0]}, #{row}"] = '#' }
  #       elsif prev[1] == nxt[1]
  #         columns = prev[0] >= nxt[0] ? nxt[0]..prev[0] : (prev[0]..nxt[0])
  #         columns.each { |column| maps["#{column}, #{prev[1]}"] = '#' }
  #       end
  #     end
  #   end
  #   self
  # end

  # def set_boundary_one
  #   @bottom_bound = use_sample ? 10 : 162
  #   @left_bound = use_sample ? 493 : 461
  #   @right_bound = use_sample ? 504 : 518
  #   self
  # end

  # def set_boundary_two
  #   @bottom_bound = use_sample ? 11 : 165
  #   @left_bound = use_sample ? 480 : 300
  #   @right_bound = use_sample ? 519 : 701
  #   self
  # end

  # def boundary
  #   { bottom_bound: @bottom_bound, left_bound: @left_bound, right_bound: @right_bound }
  # end

  # def simulate_sand_falling_one
  #   rest_sand_count = 0
  #   rest_sand_count += 1 while generate_sand.zero?

  #   @answer = rest_sand_count
  #   self
  # end

  # def simulate_sand_falling_two
  #   rest_sand_count = 0
  #   rest_sand_count += 1 while generate_sand.zero?

  #   @answer = rest_sand_count + 1 # + 1 for last sand
  #   self
  # end

  # def generate_sand(char = 'o')
  #   is_block = false
  #   unstoppable = false
  #   coordinate = SAND_SPAWN_POINT.map.to_a

  #   while !is_block && !unstoppable
  #     # down coordinate still left space
  #     if maps_with_coordinate([coordinate[0], coordinate[1] + 1]) == '.'
  #       coordinate[1] += 1

  #     # down-left coordinate still left space
  #     elsif maps_with_coordinate([coordinate[0] - 1, coordinate[1] + 1]) == '.'
  #       coordinate[0] -= 1
  #       coordinate[1] += 1

  #     # down-right coordinate still left space
  #     elsif maps_with_coordinate([coordinate[0] + 1, coordinate[1] + 1]) == '.'
  #       coordinate[0] += 1
  #       coordinate[1] += 1

  #     # no empty space remain
  #     else
  #       is_block = true
  #       if coordinate[1].zero?
  #         set_maps_with_coordinate(char, coordinate)
  #         return -2
  #       end
  #     end

  #     # reach boundary
  #     unstoppable = true if [boundary[:left_bound], boundary[:right_bound]].include?(coordinate[0])
  #   end

  #   return -1 if unstoppable

  #   set_maps_with_coordinate(char, coordinate) unless ['+', '#'].include?(maps_with_coordinate(coordinate))
  #   0
  # end

  def print_result
    puts @answer
    (@bottom_bound + 1).times do |row|
      (@left_bound..@right_bound).each { |column| print maps["#{column}, #{row}"] }
      puts row
    end
  end
end
