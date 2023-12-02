# frozen_string_literal: true

#
#
### general

def solution(part)
  case part
  when 1
    puts '=== part 1 ==='
    solution_one(load_input_file(part))
  when 2
    puts '=== part 2 ==='
    solution_two(load_input_file(part))
  else
    raise :error
  end
end

def load_input_file(idx)
  if File.file?('input.txt')
    File.readlines('input.txt', chomp: true)
  else
    load_sample_file(idx)
  end
end

def load_sample_file(idx)
  puts 'use sample'

  puts data = if File.file?("sample-#{idx}.txt")
                File.readlines("sample-#{idx}.txt", chomp: true)
              else
                File.readlines('sample.txt', chomp: true)
              end

  data
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data)
    .then { |parsed_data| parsed_data.select { |row| row[:data].all? { |tt| validate tt } } }
    .map { |validated_data| validated_data[:id] }
    .sum
end

def solution_two(input_data)
  parse(input_data)
    .then { |parsed_data| parsed_data.map { |row| find_least(row[:data]) } }
    .map(&:values)
    .map { |least_cubes| least_cubes.reduce(:*) }
    .sum
end

#
#
### build methods

def parse_row(row)
  game_number, games = row.split(':')
  {
    id: game_number.split.last.to_i,
    data: games.split(';')
               .map(&:strip)
               .map { |play| play.split(',').map(&:strip).map(&:split) }
               .map { |play| play.each_with_object({}) { |(number, color), obj| obj[color] = number } }
  }
end

def parse(data)
  data.reduce([]) { |memo, line| memo << parse_row(line) }
end

def validate(data)
  constraints = { red: 12, green: 13, blue: 14 }
  data.all? { |key, value| constraints[key.to_sym] >= value.to_i }
end

def find_least(input)
  ret = { red: 12, green: 13, blue: 14 }.transform_values { 0 }
  input.each do |data|
    data.each { |key, value| ret[key.to_sym] = [ret[key.to_sym], value.to_i].max }
  end

  ret
end

#
#
# call solution

puts solution(1)
puts solution(2)
