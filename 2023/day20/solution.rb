# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day20'
  READ_SAMPLE = !false

  def initialize(*)
    @modules = {}
    @pulses = []
    @debug = true

    super
  end
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data)

  puts_debug_message('modules', value: @modules)

  press_button

  puts_debug_message('pulses', value: @pulses)

  resolve_pulses

  nil
end

def solution_two(input_data); end

#
#
### build methods

def parse(input_data)
  input_data.each do |line|
    module_name, destination_modules = line.split(' -> ')
    destination_module_names = destination_modules.split(', ')
    @modules[module_name.gsub(/[%&]/, '')] = {
      destination_module_names:,
      module_type: if module_name == 'broadcaster'
                     'broadcaster'
                   elsif module_name.start_with?('%')
                     'Flip-flop'
                   elsif module_name.start_with?('&')
                     'Conjunction'
                   end,
      module_state: if module_name.start_with?('%')
                      :off
                    elsif module_name.start_with?('&')
                      destination_module_names.each_with_object({}) { |n, hash| hash[n] = :off }
                    end
    }
  end
end

def press_button
  # send pulses from broadcaster to its destination modules

  @pulses << @modules['broadcaster'][:destination_module_names].map do |destination_module_name|
    { pulse_type: :low, destination_module_name: }
  end
end

def resolve_pulses
  # resolve pulses from destination modules to their destination modules
  while @pulses.any?
    current_pulses = @pulses.shift
    current_pulses.each do |pulse|
      puts_debug_message('pulse', value: pulse) do
        puts "send pulse(#{pulse[:pulse_type]}) to #{pulse[:destination_module_name]}"
        puts_debug_message('receive pulse', value: @modules[pulse[:destination_module_name]][:module_state]) do
          puts "#{pulse[:destination_module_name]} received pulse(#{pulse[:pulse_type]})"
        end
        puts_debug_message('change state', value: '') do
          puts "before: #{@modules[pulse[:destination_module_name]][:module_state]}"
          case @modules[pulse[:destination_module_name]][:module_type]
          when 'Flip-flop'
            puts 'change state of Flip-flop'
          when 'Conjunction'
            puts 'change state of Conjunction'
          end
        end
        puts_debug_message('generate pulses', value: '') do
          @modules[pulse[:destination_module_name]][:destination_module_names].each do |destination_module_name|
          end

          #   case @modules[pulse[:module_name]]
          #   when 'broadcaster'
          #     puts 'broadcaster'
          #   when 'Flip-flop'
          #     puts 'Flip-flop'
          #   when 'Conjunction'
          #     puts 'Conjunction'
          #   else
          #     pp @modules[pulse[:module_name]]
          #   end
          # end
        end
      end
    end
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
