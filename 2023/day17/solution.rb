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

def get_neighbors(row = 0, col = 0, cost = 0, previous_direction = [])
  neighbors = []
  not_allowed_direction = if previous_direction.chunk_while { |a, b| a == b }.map(&:size).last.to_i == 2
                            previous_direction.last
                          end

  [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]]
    .zip(%w[up down left right].freeze)
    .each do |(r, c), direction|
    next if r == row && c == col
    next if direction == not_allowed_direction

    # skip if out of bounds
    next if r.negative? || c.negative? || r > boundary_row || c > boundary_col

    neighbors << { row: r, col: c, cost: cost + heat_lose_map[r][c].to_i, direction: }
  end

  neighbors
end

def dijkstra(start_node = [0, 0], end_node = [boundary_row, boundary_col], max_same_directions: 3)
  queue = [start_node, 0]
  visited = {}
  costs = {}
  parents = {}

  costs[start_node] = 0

  until queue.empty?
    queue.sort_by! { |_, heat, _| heat }
    current_node = queue.shift

    # skip if visited
    next if visited[current_node]

    # mark as visited
    visited[current_node] = true

    # break if end node
    break if current_node == end_node

    # get neighbors
    neighbors = get_neighbors(*current_node, heat, parents[current_node] || [])

    # add neighbors to queue
    neighbors.each do |neighbor|
      # skip if visited
      next if visited[neighbor]

      # # skip if cost is greater than max_same_directions
      # next if costs[current_node] >= max_same_directions

      # add neighbor to queue
      queue << neighbor

      # set cost
      costs[neighbor] = costs[current_node] + neighbor[:cost]

      # set parent
      parents[neighbor] = current_node
    end
  end

  # return costs
  costs
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
