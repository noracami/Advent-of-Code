# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day19'
  READ_SAMPLE = false

  def initialize(*)
    @rules = {}
    @inputs = []

    super
  end
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data)

  puts_debug_message('input_size', value: @inputs.size)
  @inputs.sum do |part|
    current_rule = @rules[:in]
    ret = nil

    while ret.nil?
      current_rule.each do |rule|
        next unless evaluate(rule[:statement], part)

        puts_debug_message('rule_destination', value: rule[:destination])

        dest = rule[:destination].to_sym
        if dest == :A
          # accept
          ret = part.values.sum
        elsif dest == :R
          # reject
          ret = 0
        end

        current_rule = @rules[dest]

        break
      end
    end

    ret
  end
end

def solution_two(input_data); end

#
#
### build methods

def parse(input_data)
  @rules, @inputs = input_data
                    .slice_when { |a, b| [a, b].any?(&:empty?) }
                    .reject { |data| data.last.empty? }

  hh = @rules.each_with_object({}) do |rule, hash|
    # px{a<2006:qkq,m>2090:A,rfg}
    rule =~ /(?<key>\w+)\{(?<value>.*)\}/
    key = $LAST_MATCH_INFO[:key]
    hash[key.to_sym] = $LAST_MATCH_INFO[:value].split(',').map do |v|
      destination, statement = v.split(':').reverse
      { destination:, statement: }
    end
  end

  @rules = hh

  @inputs.map! do |input|
    # remove '{' and '}'
    input.split('{').last.split('}').first
         .split(',').each_with_object({}) do |equation, hash|
      k, v, = equation.split('=')
      hash[k.to_sym] = v.to_i
    end
  end

  nil
end

def evaluate(rule = nil, compare_value)
  return true if rule.nil?

  rule =~ /(?<evaluator>\w+)(?<orphans>[><])(?<comp>\w+)?/
  case $LAST_MATCH_INFO[:orphans]
  when '>'
    compare_value[$LAST_MATCH_INFO[:evaluator].to_sym] > $LAST_MATCH_INFO[:comp].to_i
  when '<'
    compare_value[$LAST_MATCH_INFO[:evaluator].to_sym] < $LAST_MATCH_INFO[:comp].to_i
  else
    compare_value[$LAST_MATCH_INFO[:evaluator].to_sym] == $LAST_MATCH_INFO[:comp].to_i
  end
end

def puts_debug_message(key = nil, value:)
  return unless @debug

  puts "================ #{key} =================" if key
  puts value

  if block_given?
    yield
  elsif key
    puts ('=' * (key.size + 2)) + '=================================' + "\n\n"
  end
end
