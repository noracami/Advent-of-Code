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
    .map { |card| card.reduce(&:&).size }
    .select(&:positive?)
    .map { |n| 2**(n - 1) }
    .sum
end

def solution_two(input_data)
  bonus_cards = Hash.new { 0 }
  parse(input_data)
    .then { |data| build_card_points(data) }
    .reduce(0) do |memo, card|
    current_card_numbers = 1 + bonus_cards[card[:card_no]]
    card[:points].times { |n| bonus_cards[card[:card_no] + n + 1] += current_card_numbers }

    memo + current_card_numbers
  end
end

#
#
### build methods

def parse(data)
  winning_numbers = []
  numbers_you_have = []

  data.each do |line|
    first, second = line.split('|')
    winning_numbers << first.split(':').last.scan(/\s+\d+/).map(&:to_i)
    numbers_you_have << second.scan(/\s+\d+/).map(&:to_i)
  end

  winning_numbers.zip numbers_you_have
end

def build_card_points(data)
  data.map.with_index(1) do |card, card_no|
    {
      card_no:,
      points: card.reduce(&:&).size
    }
  end
end

#
#
# call solution

puts solution(1)
puts solution(2)
