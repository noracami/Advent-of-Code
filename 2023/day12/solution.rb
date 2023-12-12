# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day12'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data)
  # @debug = true
  # @res = 0
  input_data
    .map.with_index(1) do |line, line_idx|
      parse(line)
        .values
        .then do |springs, distribution|
          if @debug
            puts '=' * 80
            puts ('=' * 40) + " #{line_idx} " + ('=' * 40)
            puts '=' * 80
          end
          backtracking(springs, distribution)
        end
    end.then { |arr| arr.sum }
end

def solution_two(input_data)
  input_data
    .map do |line|
    parse(line, scale: 2)
      .values
      .then do |springs, distribution|
        backtracking(springs, distribution)
      end
  end.then { |arr| arr.sum }
end

#
#
### build methods

def parse(data, scale: 1)
  springs, distribution = data.split
  springs = scale.times.map { springs }.join('?')
  distribution = scale.times.map { distribution }.join(',')
  { springs: springs.chars, distribution: distribution.split(',').map(&:to_i) }
end

def backtracking(springs, distribution, arrangement: '', can_split: true)
  counter = 0
  # puts _ = { springs: springs.join, distribution: }
  # puts arrangement

  # if all distribution has it place
  if distribution.empty?
    return 0 if springs&.count('#')&.positive?

    # puts arrangement
    # puts @springs.join
    # puts ''
    # puts ''
    # @res += 1
    # pp @res
    # puts ''
    # puts _ = { springs: springs.join, distribution:, counter: }

    return 1
  end

  # if springs ran out before distribution resolve done
  if springs.nil? || springs.empty? || distribution.empty?
    # puts arrangement
    # puts _ = { springs: springs.join, distribution:, counter: }

    return 0
  end

  case springs[0]
  when '.'
    if can_split
      backtracking(springs[1..], distribution.dup, arrangement: "#{arrangement}.")
    else
      0
    end

  when '#'
    if distribution[0] == 1
      case springs[1]
      when nil
        backtracking(springs[1..], distribution[1..], arrangement: "#{arrangement}#")
      when '.', '?'
        backtracking(springs[2..], distribution[1..], arrangement: "#{arrangement}#.")
      when '#'
        0
      end
    else
      distribution[0] -= 1
      backtracking(
        springs[1..],
        distribution.dup,
        arrangement: "#{arrangement}#",
        can_split: false
      )
    end

  when '?'
    if distribution[0] == 1
      # 1. not place spring
      # treat as .
      counter += backtracking(springs[1..], distribution.dup, arrangement: "#{arrangement}.") if can_split

      # 2. place spring
      # treat as #
      unless springs[1] == '#'
        counter += backtracking(springs[2..], distribution[1..],
                                arrangement: "#{arrangement}#.")
      end
    else
      # 1. not place spring
      # treat as .
      counter += backtracking(springs[1..], distribution.dup, arrangement: "#{arrangement}.") if can_split

      # 2. place spring
      # treat as #
      unless springs[1] == '.'
        distribution[0] -= 1
        counter += backtracking(
          springs[1..],
          distribution.dup,
          arrangement: "#{arrangement}#",
          can_split: false
        )
      end
    end

    counter
  end
end
