# frozen_string_literal: true

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day05'
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
    .then { |parsed_data| build_entire_list parsed_data }
    .then { @seeds.map { |seed| to_location seed } }
    .min
end

#
#
### build methods

def parse_seeds_one(data)
  seeds, _, *data = data

  @seeds = seeds.scan(/seeds: (.+)/)[0][0].split.map(&:to_i)
  data
end

def parse_seeds_two(data)
  seeds, _, *data = data

  @seeds = seeds.scan(/seeds: (.+)/)[0][0].split.map(&:to_i).each_slice(2).flat_map do |seed_range|
    seed_range[0].upto(seed_range[0] + seed_range[1] - 1).to_a
  end

  data
end

def parse_else(data)
  maps = []
  buffer = nil
  data.each do |line|
    if line.empty? && buffer
      maps << buffer
      buffer = nil
    else
      if line =~ /(?<source>.+)-to-(?<destination>.+) map:/
        buffer = { source: Regexp.last_match[:source], destination: Regexp.last_match[:destination], data: [] }
      else
        buffer[:data] << line
      end
    end
  end
  maps << buffer if buffer
  @maps = maps
end

def build_entire_list(data)
  @entire_list = data.each_with_object({}) do |data, obj|
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

def to_location(seed, source = "seed")
  return seed unless @entire_list.key? source

  seed_range = @entire_list[source][:data].find do |range|
    range[:source] <= seed && seed <= range[:source] + range[:length] - 1
  end
  seed = seed_range[:destination] + (seed - seed_range[:source]) if seed_range

  source = @entire_list[source][:destination]
  to_location(seed, source)
end
