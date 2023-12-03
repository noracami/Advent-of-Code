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
    .then { |data| parse_symbol(data) }
    .then { |data| parse_part_numbers(data) }
    .then { @part_numbers.sum }
end

def solution_two(input_data)
  @symbols_part_numbers = Hash.new { |h, k| h[k] = [] }

  input_data
    .then { |data| parse_symbol(data) }
    .then { |data| parse_part_numbers_and_bind_to_symbol(data) }
    .then { @symbols_part_numbers.to_a.select { |_key, value| value.size == 2 } }
    .reduce(0) { |memo, (_, part_numbers)| memo + part_numbers.reduce(:*) }
end

#
#
### build methods

def parse_symbol(data)
  @symbols = {}
  data.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      @symbols["#{x}:#{y}"] = true unless char =~ /[\d\.]/
    end
  end
end

def parse_part_numbers(data)
  is_digit = /\d/
  buffer = []
  is_valid = false
  @part_numbers = []
  data.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      if (char =~ is_digit).nil? && !buffer.empty?
        @part_numbers << buffer.join.to_i if is_valid
        buffer.clear
        is_valid = false
      elsif char =~ is_digit
        buffer << char
        is_valid = true if is_valid == false && validate_number(x, y)
      end
    end
  end
end

def validate_number(x, y)
  directions = [
    [-1,  1], [0, 1], [1, 1],
    [-1,  0],         [1, 0],
    [-1, -1], [0, -1], [1, -1]
  ]
  directions.each do |d_x, d_y|
    return "#{x + d_x}:#{y + d_y}" if @symbols.key? "#{x + d_x}:#{y + d_y}"
  end

  false
end

def parse_part_numbers_and_bind_to_symbol(data)
  is_digit = /\d/
  buffer = []
  current_symbol = nil
  data.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      if (char =~ is_digit).nil? && !buffer.empty?
        @symbols_part_numbers[current_symbol] << buffer.join.to_i if current_symbol
        buffer.clear
        current_symbol = nil
      elsif char =~ is_digit
        buffer << char
        current_symbol = validate_number(x, y) if current_symbol.nil? && validate_number(x, y)
      end
    end
  end
end

#
#
# call solution

puts solution(1)
puts solution(2)
