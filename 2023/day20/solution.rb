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

class Pulse
  attr_reader :pulse_type, :destination_module, :source_module_name

  def initialize(ptype, sname, destination_module)
    @pulse_type = ptype
    @source_module_name = sname
    @destination_module = destination_module
  end

  def to_s
    "pulse(#{@pulse_type}) from #{@source_module_name} to #{@destination_module}"
  end

  def resolve
    puts "resolving #{self}"
    case destination_module[:module_type]
    when 'Flip-flop'
      if pulse_type == :low
        if destination_module[:module_state] == :off
          destination_module[:module_state] = :on
          @pulses << destination_module[:destination_module_names].map do |destination_module_name|
            Pulse.new(:high, @source_module_name, @modules[destination_module_name])
          end
        else
          destination_module[:module_state] = :off
          @pulses << destination_module[:destination_module_names].map do |destination_module_name|
            Pulse.new(:low, @source_module_name, @modules[destination_module_name])
          end
        end
      end
    when 'Conjunction'
      puts 'Conjunction'
    else
      puts 'else'
      puts destination_module_type
    end
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
    Pulse.new(:low, 'broadcaster', @modules[destination_module_name])
  end
end

def resolve_pulses
  # resolve pulses from destination modules to their destination modules
  while @pulses.any?
    current_pulses = @pulses.shift
    current_pulses.each do |pulse|
      puts_debug_message('pulse', value: pulse) do
        puts "send pulse(#{pulse.pulse_type}) to #{pulse.destination_module}"
        pulse.resolve
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
