# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day06'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data)
  parse_one(input_data)
    .map { |time, distance| find_number_of_ways_can_beat_the_record(time, distance) }
    .reduce(:*)
end

def solution_two(input_data)
  parse_two(input_data)
    .map { |time, distance| find_number_of_ways_can_beat_the_record(time, distance) }
    .reduce(:*)
end

#
#
### build methods

def parse_one(input_data)
  time_data, distance_data, = input_data
  time = time_data.split(':').last.split.map(&:to_i)
  distance = distance_data.split(':').last.split.map(&:to_i)
  time.zip(distance)
end

def parse_two(input_data)
  time_data, distance_data, = input_data
  time = time_data.split(':').last.split.join.to_i
  distance = distance_data.split(':').last.split.join.to_i
  [[time, distance]]
end

def find_number_of_ways_can_beat_the_record(time, distance)
  pp _ = { time:, distance: }
  result = (1..time).bsearch { |n| (time - n) * n > distance }
  result.upto(time - result).count
end
