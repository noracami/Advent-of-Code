# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day08'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data)
  current_position = 'AAA'

  @commands.chars.cycle.with_index(1) do |cmd, i|
    current_position = @the_map[current_position][cmd.to_sym]
    return i if current_position == 'ZZZ'
  end
end

def solution_two(input_data)
  parse(input_data)

  @the_map.select { |k, _v| k.end_with?('A') }.keys.map do |current_position|
    @commands.chars.cycle.with_index(1) do |cmd, i|
      current_position = @the_map[current_position][cmd.to_sym]
      break i if current_position.end_with? 'Z'
    end
  end
  .reduce(1, :lcm)
end

#
#
### build methods

def parse(input_data)
  @commands, _, *data = input_data
  @the_map = data.each_with_object({}) do |line, memo|
    line.scan(/(\w{3})/).flatten.then do |key, left, right|
      memo[key] = { L: left, R: right }
    end
  end
end
