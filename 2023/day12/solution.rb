# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day12'
  READ_SAMPLE = !false
end

#
#
### build solution

def solution_one(input_data)
  input_data
    .map.with_index(1) do |line, line_idx|
      parse(line)
        .values
        .then do |springs, distribution|
          puts "=" * 80
          puts "=" * 40 + " #{line_idx} " + "=" * 40
          puts "=" * 80
          backtracking(springs, distribution)
        end
    end
end

def solution_two(input_data)
end

#
#
### build methods

def parse(data)
  springs, distribution = data.split
  { springs: springs.chars, distribution: distribution.split(',').map(&:to_i) }
end

def backtracking(springs, distribution, counter: 0, arrangement: [], can_split: true)
  if distribution.empty? || springs.empty?
    if distribution.empty? || distribution.sum.zero?
      pp arrangement.join
      pp _ = { springs: springs.join, distribution:, counter: }

      return 1
    end

    0
  else
    if springs[0] == '?'
      if distribution[0].zero?
        # can only remain empty
        distribution.shift

        counter + backtracking(springs[1..], distribution.dup, arrangement: arrangement.dup << '.')
      else
        # 1. place spring
        distribution[0] -= 1

        counter += backtracking(
          springs[1..],
          distribution.dup,
          arrangement: arrangement.dup << '#',
          can_split: distribution[0].zero?
        )
        # 2. not place spring
        distribution[0] += 1

        counter += backtracking(
          springs[1..],
          distribution.dup,
          arrangement: arrangement.dup << '.',
          can_split: distribution[0].zero?
        )

        counter
      end
    elsif springs[0] == '.'
      distribution.shift if distribution[0].zero?

      counter + backtracking(springs[1..], distribution.dup, arrangement: arrangement.dup << '.')
    elsif springs[0] == '#'
      return counter if distribution[0].zero?

      distribution[0] -= 1
      if distribution[0].positive?


      counter + backtracking(
        springs[1..],
        distribution.dup,
        arrangement: arrangement.dup << '#',
        can_split: distribution[0].zero?
      )
    end
  end
end
