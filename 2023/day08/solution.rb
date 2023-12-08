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

def solution_one(input_data, processed_data = nil)
  (processed_data || input_data
    .then { |data| @command, _, *@data = data }
    .then { @the_map = @data.each_with_object({}) { |line, memo|
      key, left, right = line.scan(/(\w{3})/).flatten

      memo[key] = { L: left, R: right }
      }
    }
    .then { "AAA" })
    .then { |data|
      current_positions = data
      if processed_data
        ret = current_positions.map do |cp|
          @command.chars.cycle.with_index(1) { |cmd, i|
            cp = @the_map[cp][cmd.to_sym]
            break i if cp.end_with? "Z"
          }
        end
        ret.reduce(1, :lcm)
      else
        cp = current_positions
        @command.chars.cycle.with_index(1) { |cmd, i|
          cp = @the_map[cp][cmd.to_sym]
          return i if cp.end_with? "Z"
        }
      end
    }
end

def solution_two(input_data)
  solution_one(
    nil,
    input_data
      .then { |data| @command, _, *@data = data }
      .then { @the_map = @data.each_with_object({}) { |line, memo|
        key, left, right = line.scan(/(\w{3})/).flatten

        memo[key] = { L: left, R: right }
      }
    }.select { |k, _v| k.end_with?("A") }.keys
  )
end

#
#
### build methods

def find_goal(current_position)
  @command.chars.cycle.with_index(1) { |cmd, i|
    current_position = @the_map[current_position][cmd.to_sym]
    return i if current_position.end_with? "Z"
  }
  # input_data.map { |line| line.split.then { |hands, bid| { hands: hands.chars, bid: bid.to_i } } }
end

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
  ].each.with_index(1).to_h

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

def sort_function(obj, mode = :part1)
  case mode
  when :part1
    [determine_rank_of_hands_type(obj[:type]), obj[:hands].map { |hand| determine_rank_of_label_one(hand) }]
  when :part2
    [determine_rank_of_hands_type(obj[:type]), obj[:hands].map { |hand| determine_rank_of_label_two(hand) }]
  end
end
