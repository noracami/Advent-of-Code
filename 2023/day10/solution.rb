# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope, :components

  DAY = 'day10'
  READ_SAMPLE = false

  def initialize(_params)
    @components = { '|': [[0, 1], [0, -1]], '-': [[1, 0], [-1, 0]],
                    L: [[1, 0], [0, -1]], J: [[-1, 0], [0, -1]],
                    '7': [[-1, 0], [0, 1]], F: [[1, 0], [0, 1]] }
    super
  end
end

#
#
### build solution

def solution_one(input_data)
  build_maze(input_data)
    .then do |maze|
    maze[@start] = find_destination(@start[0], @start[1], components[:'7'])
    bfs(maze, @start).size / 2
  end
end

def solution_two(input_data)
  parse_backward(input_data).sum(&:last)
end

#
#
### build methods

def split_to_components(input_data)
  input_data.map.with_index(1) do |line, y|
    line.chars.map.with_index(1) do |char, x|
      if char == 'S'
        @start = [x, y]
        next
      end

      component = components[char.to_sym]
      component ? [x, y, component] : nil
    end
  end
end

def find_destination(coordinate_x, coordinate_y, component)
  component.map { |(d_x, d_y)| [coordinate_x + d_x, coordinate_y + d_y] }
end

def build_maze(input_data)
  split_to_components(input_data)
    .flatten(1)
    .compact
    .each_with_object({}) { |(x, y, char), memo| memo[[x, y]] = find_destination(x, y, char) }
end

def bfs(maze, start)
  queue = [start]
  visited = Hash.new(0)
  visited[start] = 1
  until queue.empty?

    current = queue.shift
    break if maze[current].nil?

    # pp _ = { current:, queue:, visited:, mc: maze[current] }

    maze[current].each do |direction|
      next if visited[direction] == 1

      queue << direction
      visited[direction] += 1
    end
  end
  visited
end
