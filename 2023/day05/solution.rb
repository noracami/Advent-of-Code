# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day05'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data)
  parse_seeds_one(input_data)
    .then { |data| parse_else(data) }
    .then { |parsed_data| build_entire_list parsed_data }
    .then { @seeds.map { |seed| to_location seed } }
    .min
end

def solution_two(input_data)
  parse_seeds_two(input_data)
    .then { |data| parse_else(data) }
    .then { step_to_location(sort_seeds(@seeds)) }
    .then { |seeds| step_to_location(sort_seeds(seeds), 'fertilizer') }
    .then { |seeds| step_to_location(sort_seeds(seeds), 'water') }
    .then { |seeds| step_to_location(sort_seeds(seeds), 'light') }
    .then { |seeds| step_to_location(sort_seeds(seeds), 'temperature') }
    .then { |seeds| step_to_location(sort_seeds(seeds), 'humidity') }
    .then { |seeds| step_to_location(sort_seeds(seeds), 'location') }
    .min_by { |seeds| seeds[0] }
    .first
end

#
#
### build methods

def parse_seeds_one(data)
  seeds, _, *data = data

  @seeds = seeds.scan(/seeds: (.+)/)[0][0].split.map(&:to_i)
  data
end

def parse_else(data, buffer = nil)
  @maps = data.push([]).each_with_object([]) do |line, maps|
    if line.empty? && buffer
      maps << buffer
      buffer = nil
    elsif line =~ /(?<source>.+)-to-(?<destination>.+) map:/
      buffer = { source: $LAST_MATCH_INFO[:source], destination: $LAST_MATCH_INFO[:destination], data: [] }
    else
      buffer[:data] << line
    end
  end
end

def build_entire_list(input_data)
  @entire_list = input_data.each_with_object({}) do |data, obj|
    obj[data[:source]] = {
      destination: data[:destination],
      data: get_range(data[:data])
    }
  end
end

def get_range(data)
  data.each_with_object([]) do |map, memo|
    destination, source, length = map.split.map(&:to_i)
    memo << { source:, destination:, length: }
  end
end

def to_location(seed, source = 'seed')
  return seed unless @entire_list.key? source

  seed_range = @entire_list[source][:data].find do |range|
    range[:source] <= seed && seed <= range[:source] + range[:length] - 1
  end
  seed = seed_range[:destination] + (seed - seed_range[:source]) if seed_range

  source = @entire_list[source][:destination]
  to_location(seed, source)
end

#
#
### part2

def parse_seeds_two(data)
  seeds, _, *data = data

  @seeds = seeds.scan(/seeds: (.+)/)[0][0].split.map(&:to_i).each_slice(2).map do |seed_range|
    [seed_range[0], seed_range[0] + seed_range[1] - 1]
  end

  data
end

def sort_seeds(seeds)
  seeds
    .sort_by { |seed| seed[0] }
    .each_with_object([]) do |seed, memo|
    if !memo.empty? && memo.last[1] >= seed[0]
      memo.last[1] = seed[1]
    else
      memo << seed
    end
  end
end

def read_maps(key)
  @maps.find { |hash| hash[:destination] == key }
end

def step_to_location(seed_ranges, step_destination = 'soil')
  ret = []
  while seed_ranges.length.positive?
    target_range = read_maps(step_destination)[:data].find do |range|
      _, source, length = range.split.map(&:to_i)
      source <= seed_ranges[0][0] && seed_ranges[0][0] <= source + length - 1
    end

    if target_range.nil?
      ret << seed_ranges.shift
    else
      destination, source, length = target_range.split.map(&:to_i)
      left_bound = destination + (seed_ranges[0][0] - source)
      right_bound = destination + [(seed_ranges[0][1] - source), length - 1].min

      ret << [left_bound, right_bound]

      if seed_ranges[0][1] > source + length - 1
        seed_ranges[0][0] = source + length
      else
        seed_ranges.shift
      end
    end
  end

  ret
end
