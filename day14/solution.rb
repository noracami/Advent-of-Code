# frozen_string_literal: true

require './utils'

class Solution
  include Utils

  attr_reader :maps, :use_sample

  DAY = 'day14'
  SAND_SPAWN_POINT = [500, 0].freeze

  def self.part1
    Solution.new('part1')
            # .use_sample_file
            .load_input
            .build_maps
            .build_rocks
            .set_boundary
            .simulate_sand_falling
            .print_result
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

  def set_maps_with_coordinate(value, coordinate = [])
    raise 'invalid coordinate' if coordinate.size != 2

    maps[coordinate.map(&:to_s).join(', ')] = value
  end

  def maps_with_coordinate(coordinate = [])
    raise 'invalid coordinate' if coordinate.size != 2

    maps[coordinate.map(&:to_s).join(', ')]
  end

  def build_maps
    @maps = {}
    201.times do |row|
      (461..519).each do |column|
        set_maps_with_coordinate('.', [column, row])
      end
    end
    set_maps_with_coordinate('+', SAND_SPAWN_POINT)
    self
  end

  def build_rocks
    @res
      .map { |line| line.split(' -> ').map { |el| el.split(',').map(&:to_i) } }
      .each do |line|
      line.each_cons(2) do |prev, nxt|
        if prev[0] == nxt[0]
          rows = prev[1] >= nxt[1] ? nxt[1]..prev[1] : prev[1]..nxt[1]
          rows.each { |row| maps["#{prev[0]}, #{row}"] = '#' }
        elsif prev[1] == nxt[1]
          columns = prev[0] >= nxt[0] ? nxt[0]..prev[0] : (prev[0]..nxt[0])
          columns.each { |column| maps["#{column}, #{prev[1]}"] = '#' }
        end
      end
    end
    self
  end

  def set_boundary
    @bottom_bound = use_sample ? 10 : 162
    @left_bound = use_sample ? 493 : 461
    @right_bound = use_sample ? 504 : 518
    self
  end

  def boundary
    { bottom_bound: @bottom_bound, left_bound: @left_bound, right_bound: @right_bound }
  end

  def simulate_sand_falling
    rest_sand_count = 0
    rest_sand_count += 1 while generate_sand.zero?

    @answer = rest_sand_count
    self
  end

  def generate_sand(char = 'o')
    is_block = false
    unstoppable = false
    coordinate = SAND_SPAWN_POINT.map.to_a

    while !is_block && !unstoppable
      # down coordinate still left space
      if maps_with_coordinate([coordinate[0], coordinate[1] + 1]) == '.'
        coordinate[1] += 1

      # down-left coordinate still left space
      elsif maps_with_coordinate([coordinate[0] - 1, coordinate[1] + 1]) == '.'
        coordinate[0] -= 1
        coordinate[1] += 1

      # down-right coordinate still left space
      elsif maps_with_coordinate([coordinate[0] + 1, coordinate[1] + 1]) == '.'
        coordinate[0] += 1
        coordinate[1] += 1

      # no empty space remain
      else
        is_block = true
      end

      # reach boundary
      unstoppable = true if [boundary[:left_bound], boundary[:right_bound]].include?(coordinate[0])
    end

    return -1 if unstoppable

    set_maps_with_coordinate(char, coordinate) unless ['+', '#'].include?(maps_with_coordinate(coordinate))
    0
  end

  def print_result
    puts @answer
    (@bottom_bound + 1).times do |row|
      (@left_bound..@right_bound).each { |column| print maps["#{column}, #{row}"] }
      puts row
    end
  end
end
