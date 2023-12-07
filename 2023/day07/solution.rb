# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day07'
  READ_SAMPLE = false
end

#
#
### build solution

def solution_one(input_data, processed_data = nil)
  (processed_data || parse(input_data).each { |obj| obj[:type] = determine_hands_type(obj[:hands]) })
    .sort_by { |obj| sort_function(obj) }
    .zip(1..)
    .reduce(0) { |memo, (obj, multiply)| memo + (obj[:bid] * multiply) }
end

def solution_two(input_data)
  solution_one(
    nil,
    parse(input_data).each { |obj| obj[:type] = determine_hands_type(mix_joker(obj[:hands])) }
  )
end

#
#
### build methods

def parse(input_data)
  @lines = input_data.map { |line| line.split.then { |hands, bid| { hands: hands.chars, bid: bid.to_i } } }
end

def determine_hands_type(hands)
  case hands.tally.size
  when 1 then :five_of_a_kind
  when 2 then hands.tally.values.include?(4) ? :four_of_a_kind : :full_house
  when 3 then hands.tally.values.include?(3) ? :three_of_a_kind : :two_pair
  when 4 then :one_pair
  else :high_card
  end
end

def mix_joker(hands)
  return hands if hands.count('J') == 5

  substitute = hands.reject { |hand| hand == 'J' }.tally.max_by(&:last).first
  hands.map { |hand| hand == 'J' ? substitute : hand }
end

def determine_rank_of_hands_type(hands_type)
  @rank_list ||= %i[
    high_card one_pair two_pair three_of_a_kind full_house four_of_a_kind five_of_a_kind
  ].zip(1..).to_h

  @rank_list[hands_type]
end

def determine_rank_of_label_one(card_label)
  rank_list = {
    A: 14, K: 13, Q: 12, J: 11, T: 10, '9': 9, '8': 8, '7': 7,
    '6': 6, '5': 5, '4': 4, '3': 3, '2': 2
  }

  rank_list[card_label.to_sym]
end

def determine_rank_of_label_two(card_label)
  rank = determine_rank_of_label_one(card_label)
  rank == 11 ? 1 : rank
end

def sort_function(obj)
  [
    determine_rank_of_hands_type(obj[:type]),
    obj[:hands].map { |hand| determine_rank_of_label_one(hand) }
  ]
end
