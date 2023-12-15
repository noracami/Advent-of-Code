# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day15'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data)
  # @debug = true
  # @res = 0
  hash_it = ->(input) {
    input.codepoints.reduce(0) do |memo, ascii_code|
      (memo + ascii_code).then { multiply(_1, 17) }.then { get_remainder(_1, 256) }
    end
  }

  input_data[0].split(',').map(&hash_it).sum
end

def solution_two(input_data)
  hash_it = ->(input) {
    input.codepoints.reduce(0) do |memo, ascii_code|
      (memo + ascii_code).then { multiply(_1, 17) }.then { get_remainder(_1, 256) }
    end
  }

  regex = /([a-z]+)([=-])(\d?)/
  boxes = 256.times.map { |i| [i, { hash: {}, list: []}] }.to_h

  input_data[0]
    .split(',')
    .each do |step|
      step.scan(regex) do |m|
        label, sign, value = m
        box_no = hash_it.(label)
        case sign
        when '='
          if boxes[box_no][:hash][label]
            boxes[box_no][:hash][label][:value] = value
          else
            boxes[box_no][:hash][label] = { value: value, label: label }
            boxes[box_no][:list] << boxes[box_no][:hash][label]
          end
        when '-'
          if boxes[box_no][:hash][label]
            boxes[box_no][:list].delete_if { |h| h[:label] == label }
            boxes[box_no][:hash].delete(label)
          end
        end
      end
    end
    boxes
      .reject { |_, v| v[:hash].empty? }
      .map { |box_no, v| v[:list].map.with_index(1) { |h, index| index * h[:value].to_i }.sum * (box_no + 1) }
      .sum
end

#
#
### build methods

def multiply(input, factor)
  input * factor
end

def get_remainder(input, divisor)
  input % divisor
end
