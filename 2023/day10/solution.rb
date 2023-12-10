# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope, :components

  DAY = 'day10'
  READ_SAMPLE = false

  def initialize(*)
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
    .then { |maze| bfs(maze, @start) }
    .size / 2
end

def solution_two(input_data)
  build_maze(input_data)
    .then { |maze| bfs(maze, @start) }
    .then { |visited| find_captured_points(input_data, visited) }
    .flatten
    .count(:captured_animals)
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
    .update({ @start => find_destination(@start[0], @start[1], components[:'7']) })
end

def find_captured_points(input_data, visited)
  input_data.map.with_index(1) do |line, y|
    status = { encountered_pipe: nil, can_capture: false }
    line.chars.map.with_index(1) do |char, x|
      if visited[[x, y]].zero?
        :captured_animals if status[:can_capture]
      else
        handle_encountered_pipe(status, char)
      end
    end
  end
end

def handle_encountered_pipe(status, char, previous_char = status[:encountered_pipe])
  if (char == '|') || (char == 'J' && (previous_char == 'F')) || (char == '7' && (previous_char == 'L'))
    status[:can_capture] = !status[:can_capture]
  end

  update_encountered_pipe(status, char)

  nil
end

def update_encountered_pipe(status, char)
  status[:encountered_pipe] = char if %w[F L].include?(char)
  status[:encountered_pipe] = nil if %w[J 7].include?(char)
end

# rubocop:disable Metrics/MethodLength
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
# rubocop:enable Metrics/MethodLength
