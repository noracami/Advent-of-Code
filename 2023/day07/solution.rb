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

def solution_one(input_data)
  parse(input_data)
    .each { |obj| obj[:type] = determine_hands_type(obj[:hands]) }
    .sort_by { |obj|
      [
        determine_rank_of_hands_type(obj[:type]),
        obj[:hands].map { |hand| determine_rank_of_label_one(hand) }
        ]
      }
    .map.with_index(1) { |obj, multiply| obj[:bid] * multiply }
    .sum
end

def solution_two(input_data)
  parse(input_data)
    .each { |obj| obj[:type] = determine_hands_type(mix_joker(obj[:hands])) }
    .sort_by { |obj|
      [
        determine_rank_of_hands_type(obj[:type]),
        obj[:hands].map { |hand| determine_rank_of_label_two(hand) }
        ]
      }
    .map.with_index(1) { |obj, multiply| obj[:bid] * multiply }
    .sum
end

#
#
### build methods

def parse(input_data)
  @lines = input_data
    .map { |line|
      hands, bid = line.split
      {
        hands: hands.chars,
        bid: bid.to_i,
        type: nil
      }
    }
end

def determine_hands_type(hands)
  if hands.tally.size == 1
    :five_of_a_kind
  elsif hands.tally.size == 2
    if hands.tally.values.include?(4)
      :four_of_a_kind
    else
      :full_house
    end
  elsif hands.tally.size == 3
    if hands.tally.values.include?(3)
      :three_of_a_kind
    else
      :two_pair
    end
  elsif hands.tally.size == 4
    :one_pair
  else
    :high_card
  end
end

def mix_joker(hands)
  return hands if hands.count('J') == 5

  substitute = hands.reject { |hand| hand == 'J' }.tally.then{pp _1}.max_by(&:last).first
  hands.map { |hand| hand == 'J' ? substitute : hand }
end

def determine_rank_of_hands_type(hands_type)
  rank_list = {
    five_of_a_kind: 7,
    four_of_a_kind: 6,
    full_house: 5,
    three_of_a_kind: 4,
    two_pair: 3,
    one_pair: 2,
    high_card: 1
  }

  rank_list[hands_type]
end

def determine_rank_of_label_one(card_label)
  rank_list = {
    'A': 14, 'K': 13, 'Q': 12, 'J': 11, 'T': 10, '9': 9, '8': 8, '7': 7,
    '6': 6, '5': 5, '4': 4, '3': 3, '2': 2
  }

  rank_list[card_label.to_sym]
end

def determine_rank_of_label_two(card_label)
  rank = determine_rank_of_label_one(card_label)
  rank == 11 ? 1 : rank
end
