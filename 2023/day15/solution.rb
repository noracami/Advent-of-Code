# frozen_string_literal: true

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
  parse(input_data).sum { hash_it _1 }
end

def solution_two(input_data)
  regex = /([a-z]+)([=-])(\d?)/
  boxes = 256.times.to_h { |i| [i, { hash: {}, list: [] }] }

  parse(input_data)
    .each do |step|
      label, sign, value = step.scan(regex)[0]
      box_no = hash_it(label)
      case sign
      when '='
        if boxes[box_no][:hash][label]
          boxes[box_no][:hash][label][:value] = value
        else
          boxes[box_no][:hash][label] = { value:, label: }
          boxes[box_no][:list] << boxes[box_no][:hash][label]
        end

      when '-'
        if boxes[box_no][:hash][label]
          boxes[box_no][:list].delete_if { |h| h[:label] == label }
          boxes[box_no][:hash].delete(label)
        end
      end
    end

  boxes
    .reject { |_, v| v[:hash].empty? }
    .sum { |box_no, v| v[:list].map.with_index(1) { |h, index| index * h[:value].to_i }.sum * (box_no + 1) }
end

#
#
### build methods

def parse(input_data)
  input_data[0].split(',')
end

def hash_it(input)
  input.codepoints.reduce(0) do |memo, ascii_code|
    (memo + ascii_code)
      .then { |value| value * 17 }
      .then { |value| value % 256 }
  end
end
