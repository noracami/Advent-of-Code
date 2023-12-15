# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope, :dp

  DAY = 'day13'
  READ_SAMPLE = !false
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data)
    .each do |da|
    check_mirror(da)
  end
end

def solution_two(input_data)
  input_data
    .map do |line|
    parse(line, scale: 5)
      .values
      .then do |springs, distribution|
        backtracking_dp(springs, distribution)
      end
  end.then { |arr| arr.sum }
end

#
#
### build methods

def parse(data)
  res = []
  buffer = []
  data.each do |line|
    if line.empty?
      res << buffer
      buffer.clear
    else
      buffer << line
    end
  end

  res << buffer unless buffer.empty?

  res
end

def check_mirror(data)
  check_horizontal(data) || check_vertical(data)
end

def check_horizontal(data)
  check_left(data) || check_right(data.reverse)
end

def check_left(data)
  max_right = nil

  data.each_with_index do |line, index|
    next if index.zero?
    next unless line == data.first

    max_right = index if (0...index).all? { |idx| data[idx] == data[index - idx] }
  end

  pp _ = { max_right: }

  max_right
end

def check_right(data)
  max_left = 0

  data.each_with_index do |line, index|
    next if index.zero?
    next unless line == data.first

    max_left = data.size - index if (0...index).all? { |idx| data[idx] == data[index - idx] }
  end

  pp _ = { max_left: }

  max_left
end

def check_vertical(data)
  data.each_with_index do |line, idx|
    return true if line[idx] == '\\'
  end

  false
end

def backtracking(springs, distribution, can_split: true)
  return springs&.count('#')&.positive? ? 0 : 1 if distribution.empty?

  # if springs ran out before distribution resolve done
  return 0 if springs.nil? || springs.empty?

  case springs[0]
  when '.'
    can_split ? backtracking(springs[1..], distribution.dup) : 0

  when '#'
    if distribution[0] == 1
      case springs[1]
      when nil
        backtracking(springs[1..], distribution[1..])
      when '.', '?'
        backtracking(springs[2..], distribution[1..])
      when '#'
        0
      end
    else
      distribution[0] -= 1
      backtracking(
        springs[1..],
        distribution.dup,
        can_split: false
      )
    end

  when '?'
    counter = 0
    if distribution[0] == 1
      # 1. not place spring
      # treat as .
      counter += backtracking(springs[1..], distribution.dup) if can_split

      # 2. place spring
      # treat as #
      counter += backtracking(springs[2..], distribution[1..]) unless springs[1] == '#'
    else
      # 1. not place spring
      # treat as .
      counter += backtracking(springs[1..], distribution.dup) if can_split

      # 2. place spring
      # treat as #
      unless springs[1] == '.'
        distribution[0] -= 1
        counter += backtracking(
          springs[1..],
          distribution.dup,
          can_split: false
        )
      end
    end

    counter
  end
end

def backtracking_dp(springs, distribution, can_split: true)
  return springs&.count('#')&.positive? ? 0 : 1 if distribution.empty?

  # if springs ran out before distribution resolve done
  return 0 if springs.nil? || springs.empty?

  key = [springs, distribution, can_split].hash
  return @dp[key] if @dp.key?(key)

  case springs[0]
  when '.'
    @dp[key] = can_split ? backtracking_dp(springs[1..], distribution.dup) : 0

  when '#'
    if distribution[0] == 1
      case springs[1]
      when nil
        @dp[key] = backtracking_dp(springs[1..], distribution[1..])
      when '.', '?'
        @dp[key] = backtracking_dp(springs[2..], distribution[1..])
      when '#'
        @dp[key] = 0
      end
    else
      distribution[0] -= 1
      @dp[key] = backtracking_dp(
        springs[1..],
        distribution.dup,
        can_split: false
      )
    end

  when '?'
    counter = 0
    if distribution[0] == 1
      # 1. not place spring
      # treat as .
      counter += backtracking_dp(springs[1..], distribution.dup) if can_split

      # 2. place spring
      # treat as #
      counter += backtracking_dp(springs[2..], distribution[1..]) unless springs[1] == '#'
    else
      # 1. not place spring
      # treat as .
      counter += backtracking_dp(springs[1..], distribution.dup) if can_split

      # 2. place spring
      # treat as #
      unless springs[1] == '.'
        distribution[0] -= 1
        counter += backtracking_dp(
          springs[1..],
          distribution.dup,
          can_split: false
        )
      end
    end

    @dp[key] = counter
  end
end
