# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope, :expanded_galaxies, :original_galaxies

  DAY = 'day11'
  READ_SAMPLE = false

  def initialize(*)
    @original_galaxies = []
    @expanded_galaxies = []
    @original_manhattan_distance = 0
    @expanded_manhattan_distance = 0
    @diff = 0
    super
  end
end

#
#
### build solution

def solution_one(input_data)
  expand_space(input_data)
    .then { |space| expanded_galaxy(space) }
    .then { expanded_galaxies.combination(2).sum { |(a, b)| calculate_manhattan_distance(a, b) } }
end

def solution_two(input_data)
  get_original_galaxy(input_data)
    .then { |input_data| expand_space(input_data)}
    .then { |space| expanded_galaxy(space) }
    .then do
      @original_manhattan_distance = original_galaxies.combination(2).sum { |(a, b)| calculate_manhattan_distance(a, b) }
      @expanded_manhattan_distance = expanded_galaxies.combination(2).sum { |(a, b)| calculate_manhattan_distance(a, b) }
      @diff = @expanded_manhattan_distance - @original_manhattan_distance
      @original_manhattan_distance + (@diff * (1_000_000 - 1))
    end
end

#
#
### build methods

def expand_space(input_data)
  tmp_space = []
  new_space = []
  input_data
    .map(&:chars).transpose.each do |line|
      tmp_space << line
      tmp_space << line if line.all? { |char| char == '.' }
    end.then { tmp_space.transpose }.each.with_index(1) do |line, i|
      new_space << line.join
      new_space << line.join if line.all? { |char| char == '.' }
    end.then{ new_space }
end

def expanded_galaxy(input_data)
  input_data.map.with_index(1) do |line, y|
    line.chars.map.with_index(1) do |char, x|
      expanded_galaxies << [x, y] if char == '#'
    end
  end
end

def get_original_galaxy(input_data)
  input_data.map.with_index(1) do |line, y|
    line.chars.map.with_index(1) do |char, x|
      original_galaxies << [x, y] if char == '#'
    end
  end

  input_data
end

def calculate_manhattan_distance(point_one, point_two)
  (point_one[0] - point_two[0]).abs + (point_one[1] - point_two[1]).abs
end
