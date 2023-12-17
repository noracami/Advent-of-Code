# frozen_string_literal: true

require 'io/console'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope, :boundary_row, :boundary_col, :heat_lose_map

  DAY = 'day17'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data)
    .then { |data| build_heat_lose_map(data) }
    .then { |data| build_boundary(data) }
    .then { puts "boundary: #{@boundary_row}, #{@boundary_col}" }
    .then { pp dijkstra }
    .then { nil }
end

def solution_two(input_data); end

#
#
### build methods

def parse(input_data)
  input_data
end

def build_heat_lose_map(data)
  @heat_lose_map = data.map(&:chars)
  data
end

def build_boundary(data)
  @boundary_row = data.size - 1
  @boundary_col = data[0].size - 1
end

def get_neighbors(row, col)
  neighbors = []
  [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]]
    .zip(%w[up down left right].freeze)
    .each do |(r, c), direction|
    next if r == row && c == col

    # skip if out of bounds
    next if r.negative? || c.negative? || r > boundary_row || c > boundary_col

    neighbors << { row: r, col: c, cost: heat_lose_map[r][c].to_i, direction: }
  end

  neighbors
end

def dijkstra
  # initialize distance to infinity
  distance = Hash.new { |h, k| h[k] = { cost: Float::INFINITY } }

  # initialize entry point to 0
  distance[[0, 0]] = { cost: 0, directions: [] }

  # initialize queue
  queue = [[0, 0, get_neighbors(0, 0)]]

  counter = 0

  visited = {}

  # while queue is not empty
  until queue.empty?
    queue.sort_by! { |(r, c, _)| distance[[r, c]][:cost] }

    # get first element in queue
    row, col, neighbors = queue.pop

    # for each neighbor
    neighbors.each do |neighbor|
      counter += 1
      next if visited[[neighbor[:row], neighbor[:col]]]

      $stdout.clear_screen

      puts_debug_message('current_position', value: { counter:, row:, col: }) do
        puts_debug_message('get_neighbors', value: neighbors)
      end

      # calculate new distance
      new_distance = distance[[row, col]][:cost] + neighbor[:cost]

      puts_debug_message('neighbor', value: neighbor) do
        puts_debug_message(
          'info',
          value: {
            new_distance:,
            previous_distance: distance[[neighbor[:row], neighbor[:col]]][:cost]
          }
        )
      end

      puts_debug_message(
        value: 'compare if new distance < current distance: ' \
               "#{new_distance < distance[[neighbor[:row], neighbor[:col]]][:cost]}" \
               "\n\n"
      )

      # skip unless new distance is less than current distance
      unless new_distance < distance[[neighbor[:row], neighbor[:col]]][:cost]
        pp 'skip because new distance is not less than current distance'

        # read = $stdin.gets.chomp
        # return :quit if read == 'q'

        next
      end

      # otherwise check direction
      puts_debug_message(
        'check direction',
        value: ''
      ) do
        puts_debug_message('check if incoming direction is legal', value: '') do
          puts "previous directions: #{distance[[row, col]][:directions]}"
          puts "neighbor[:direction]: #{neighbor[:direction]}"
        end
      end

      last_directions = distance[[row, col]][:directions].chunk_while { |a, b| a == b }.map(&:tally).last

      # skip if same directions more than 3
      if (row != 0 || col != 0) && last_directions[neighbor[:direction]] && last_directions[neighbor[:direction]] >= 3
        pp 'skip because same directions should not be more than 3'

        # read = $stdin.gets.chomp
        # return :quit if read == 'q'

        next
      end

      # if counter == 20
      #   pp last_directions
      #   pp _ = { row:, col:, a: last_directions[neighbor[:direction]], b: (last_directions[neighbor[:direction]] >= 3) }
      #   raise 'stop'
      # end

      # otherwise update distance and directions

      # update directions
      distance[[neighbor[:row], neighbor[:col]]][:directions] =
        distance[[row, col]][:directions] + [neighbor[:direction]]

      # update distance
      distance[[neighbor[:row], neighbor[:col]]][:cost] = new_distance

      # mark as visited
      visited[[neighbor[:row], neighbor[:col]]] = true

      # add neighbor to queue
      queue << [neighbor[:row], neighbor[:col], get_neighbors(neighbor[:row], neighbor[:col])]

      puts_debug_message(
        'update distance and directions',
        value: {
          row: neighbor[:row],
          col: neighbor[:col],
          distance: distance[[neighbor[:row], neighbor[:col]]][:cost],
          directions: distance[[neighbor[:row], neighbor[:col]]][:directions]
        }
      )

      # read = $stdin.gets.chomp
      # return :quit if read == 'q'
    end
  end

  # return distance
  # distance[[boundary_row, boundary_col].hash]
  (boundary_row + 1).times.map { |r| (boundary_col + 1).times.map { |c| distance[[r, c]] } }
end

def puts_debug_message(key = nil, value:)
  puts "================ #{key} =================" if key
  puts value

  if block_given?
    yield
  elsif key
    puts ('=' * (key.size + 2)) + '=================================' + "\n\n"
  end
end
