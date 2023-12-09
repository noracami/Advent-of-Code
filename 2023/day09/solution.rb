# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day09'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data)
  parse_forward(input_data).sum
end

def solution_two(input_data)
  parse_backward(input_data).sum(&:last)
end

#
#
### build methods

def parse_forward(data)
  data.map do |line|
    sequence = [line.split.map(&:to_i)]
    sequence << sequence.last.each_cons(2).map { |a, b| b - a } until sequence.last.all?(&:zero?)
    sequence.map(&:last).sum
  end
end

def parse_backward(data)
  data.map do |line|
    sequence = [line.split.map(&:to_i)]
    sequence << sequence.last.each_cons(2).map { |a, b| b - a } until sequence.last.all?(&:zero?)
    sequence.map(&:first).reverse.reduce([0]) { |memo, number| memo << (number - memo.last) }
  end
end
