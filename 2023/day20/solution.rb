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
  attr_reader :pulse_type, :source_module_name, :dest_module_name

  @@modules = {}

  def self.load_modules(modules)
    @@modules = modules
  end

  def modules
    @@modules
  end

  def initialize(ptype, sname, dname)
    @pulse_type = ptype
    @source_module_name = sname
    @dest_module_name = dname
  end

  def to_s
    "pulse(#{pulse_type}) from #{source_module_name} to #{dest_module_name}"
  end

  def resolve
    puts "resolving #{self}"
    dest = modules[dest_module_name]
    puts "#{dest_module_name}(#{modules[dest_module_name][:module_state]})"
    puts "=> #{pulse_type}"
    case dest[:module_type]
    when 'Flip-flop'
      if pulse_type == :low
        if dest[:module_state] == :off
          dest[:module_state] = :on
          puts "#{dest_module_name}(#{modules[dest_module_name][:module_state]})"
          dest[:destination_module_names].map do |destination_module_name|
            Pulse.new(:high, dest_module_name, destination_module_name)
          end
        else
          dest[:module_state] = :off
          puts "#{dest_module_name}(#{modules[dest_module_name][:module_state]})"
          dest[:destination_module_names].map do |destination_module_name|
            Pulse.new(:low, dest_module_name, destination_module_name)
          end
        end
      else
        puts ':skip'
      end
    when 'Conjunction'
      puts 'update state from input'
      dest[:module_state][source_module_name] = pulse_type
      generate_pulse_type = dest[:module_state].values.all?(:high) ? :low : :high
      dest[:destination_module_names].map do |destination_module_name|
        Pulse.new(generate_pulse_type, dest_module_name, destination_module_name)
      end
    else
      puts 'else'
      puts dest[:module_type]
    end
  end
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data)

  puts_debug_message('modules', value: @modules)

  Pulse.load_modules(@modules)

  press_button

  excution_loops = 1

  excution_loops.times do |i|
    puts_debug_message('Round', value: i + 1) do
      puts_debug_message('pulses', value: @pulses)

      resolve_pulses

      puts '=== Round end ==='
    end
  end

  nil
end

def solution_two(input_data); end

#
#
### build methods

def parse(input_data)
  node_parents = {}
  input_data.each do |line|
    module_name, destination_modules = line.split(' -> ')
    destination_module_names = destination_modules.split(', ')
    destination_module_names.each do |destination_module_name|
      node_parents[destination_module_name] ||= []
      node_parents[destination_module_name] << module_name.gsub(/[%&]/, '')
    end
    @modules[module_name.gsub(/[%&]/, '')] = {
      destination_module_names:,
      module_type: if module_name == 'broadcaster'
                     'broadcaster'
                   elsif module_name.start_with?('%')
                     'Flip-flop'
                   elsif module_name.start_with?('&')
                     'Conjunction'
                   end,
      module_state: (:off if module_name.start_with?('%'))
    }
  end
  @modules.select { |_k, v| v[:module_type] == 'Conjunction' }.each do |k, v|
    v[:module_state] = node_parents[k].each_with_object({}) { |n, hash| hash[n] = :low }
  end
  # elsif module_name.start_with?('&')
  #   raise module_name
  #   destination_module_names.each_with_object({}) { |n, hash| hash[n] = :low }
end

def press_button
  # send pulses from broadcaster to its destination modules

  @pulses << @modules['broadcaster'][:destination_module_names].map do |destination_module_name|
    Pulse.new(:low, 'broadcaster', destination_module_name)
  end
end

def resolve_pulses
  # resolve pulses from destination modules to their destination modules
  while @pulses.any?
    current_pulses = @pulses.shift
    current_pulses.each do |pulse|
      puts_debug_message('resolving pulse', value: pulse) do
        ret = pulse.resolve
        @pulses << ret unless ret.nil?
        puts '================ pulse resolved ================'
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
