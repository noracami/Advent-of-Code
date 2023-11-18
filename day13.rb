# frozen_string_literal: true

require './utils'

DEBUG = false

class Solution
  extend Utils

  def self.string_to_array(input)
    return if input[0] != '['

    current_array = []
    not_close_array = [current_array]
    number_cache = []
    input[1..].each_char do |char|
      case char
      when '['
        not_close_array << current_array
        current_array << []
        current_array = current_array.last
      when ']'
        return -1 if not_close_array.empty?

        unless number_cache.empty?
          current_array << number_cache.join.to_i
          number_cache.clear
        end
        current_array = not_close_array.pop
      when /\d/
        number_cache << char
      when ','
        unless number_cache.empty?
          current_array << number_cache.join.to_i
          number_cache.clear
        end
      end
    end

    current_array
  end

  def self.compare_rest(rest)
    puts 'run compare_rest' if DEBUG

    if rest.all?(&:empty?)
      0
    elsif rest[0].empty?
      -1
    elsif rest[1].empty?
      1
    else
      left = rest[0].shift
      right = rest[1].shift
      compare(left, right, rest)
    end
  end

  def self.compare_integer(left, right)
    puts 'run compare_integer' if DEBUG

    left <=> right
  end

  def self.compare_list(left, right)
    puts 'run compare_list' if DEBUG

    if left.empty? && !right.empty?
      -1
    elsif !left.empty? && right.empty?
      1
    elsif left.empty? && right.empty?
      0
    elsif !left.empty? && !right.empty?
      compare(left[0], right[0], [left[1..], right[1..]])
    end
  end

  def self.compare(left, right, rest = [])
    puts 'run compare' if DEBUG
    pp _ = { left:, right:, rest: } if DEBUG

    ret = if [left, right].all? { _1.instance_of?(Integer) }
            compare_integer(left, right)
          elsif [left, right].all? { _1.instance_of?(Array) }
            compare_list(left, right)
          elsif left.instance_of?(Integer)
            compare_list([left], right)
          elsif right.instance_of?(Integer)
            compare_list(left, [right])
          end

    puts 'check return' if DEBUG
    puts ":: #{ret}" if DEBUG

    case ret
    when -1 then -1
    when 1 then 1
    when 0 then compare_rest(rest)
    end
  end

  def self.part1
    filename = './day13-sample-1.txt'
    # filename = './day13-input-1.txt'
    res = parse_input(filename)

    res = res
          .each_slice(3).each(&:pop)
          .map { |str| string_to_array(str) } # [18..20]
          # .then { pp _1 }
          .compact
          .each_slice(2).map do |left_packet, right_packet|
      compare(left_packet, right_packet)
    end

    answer = res.zip(1..).reduce(0) do |memo, (result, idx)|
      pp _ = { memo:, result:, idx: } if DEBUG
      result == -1 ? memo + idx : memo
    end

    puts answer
  end
end
