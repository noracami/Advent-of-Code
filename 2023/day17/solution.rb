# frozen_string_literal: true

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
  queue = [[0, 0]]

  # while queue is not empty
  until queue.empty?

    # get first element in queue
    row, col = queue.shift

    # get neighbors
    neighbors = get_neighbors(row, col)

    puts '============= get_neighbors ==============='
    pp "row: #{row}, col: #{col}"
    pp 'neighbors:'
    pp neighbors
    puts '============================================'

    # for each neighbor
    neighbors.each do |neighbor|
      puts '================ neighbor ================='
      pp "neighbor: #{neighbor}"
      # calculate new distance
      new_distance = distance[[row, col]][:cost] + neighbor[:cost]
      pp "new_distance: #{new_distance}"

      pp [neighbor[:row], neighbor[:col]]
      pp distance[999][:cost]
      pp "previous distance: #{distance[[neighbor[:row], neighbor[:col]]][:cost]}"

      print 'compare if new distance < current distance: '
      puts new_distance < distance[[neighbor[:row], neighbor[:col]]][:cost]
      puts ''

      # if new distance is less than current distance
      next unless new_distance < distance[[neighbor[:row], neighbor[:col]]][:cost]

      pp "updating direction for #{neighbor[:row]}, #{neighbor[:col]}"
      pp distance[[row, col]][:directions]
      pp "neighbor[:direction]: #{neighbor[:direction]}"

      if row != 0 && col != 0
        read = $stdin.gets.chomp
        last_directions = distance[[row, col]][:directions].chunk_while { |a, b| a == b }.map(&:tally).last
        if last_directions[neighbor[:direction]] && last_directions[neighbor[:direction]] >= 3
          pp 'skip because same directions should not be more than 3'
          next
        end
      end

      distance[[neighbor[:row], neighbor[:col]]][:directions] =
        distance[[row, col]][:directions] + [neighbor[:direction]]

      # update distance
      pp "updating distance for #{neighbor[:row]}, #{neighbor[:col]}"

      distance[[neighbor[:row], neighbor[:col]]][:cost] = new_distance

      # add neighbor to queue
      queue << [neighbor[:row], neighbor[:col]]
    end
  end

  # return distance
  # distance[[boundary_row, boundary_col].hash]
  (boundary_row + 1).times.map { |r| (boundary_col + 1).times.map { |c| distance[[r, c]] } }
end
