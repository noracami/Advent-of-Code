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
  input_data
    .map { |line| find_left(line) + find_right(line) }
    .map(&:to_i)
    .sum
end

def solution_two(input_data)
  input_data
    .map { |line| find_left_include_letters(line) + find_right_include_letters(line) }
    .map(&:to_i)
    .sum
end

#
#
### build methods

def find_left(line)
  line[line.index(/\d/)]
end

def find_right(line)
  line[line.rindex(/\d/)]
end

def find_left_include_letters(line)
  digit_found = line.index(/\d/)
  digit_found &&= [digit_found, line[digit_found]]
  score_map = %w[one two three four five six seven eight nine].zip('1'..'9')
  score_map
    .map { |regexp, value| line.index(regexp) && [line.index(regexp), value] }
    .push(digit_found)
    .compact
    .min_by { |idx, _value| idx }
    .then { |_idx, value| value }
end

def find_right_include_letters(line)
  digit_found = line.rindex(/\d/)
  digit_found &&= [digit_found, line[digit_found]]
  score_map = %w[one two three four five six seven eight nine].zip('1'..'9')
  score_map
    .map { |regexp, value| line.rindex(regexp) && [line.rindex(regexp), value] }
    .push(digit_found)
    .compact
    .max_by { |idx, _value| idx }
    .then { |_idx, value| value }
end

#
#
# call solution

puts solution(1)
puts solution(2)
