# frozen_string_literal: true

require 'English'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day20'
  READ_SAMPLE = false

  def initialize(*)
    @modules = {}
    @pulses = []
    @debug = false

    super
  end
end

class Pulse
  attr_reader :pulse_type, :source_module_name, :dest_module_name

  @@modules = {}
  @@counter = { low: 0, high: 0 }
  @@counter_two = {
    tn: { low: 0, high: 0 },
    st: { low: 0, high: 0 },
    dt: { low: 0, high: 0 },
    hh: { low: 0, high: 0 }
  }

  def self.load_modules(modules)
    @@modules = modules
  end

  def modules
    @@modules
  end

  def count_pulse
    @@counter[pulse_type] += 1
  end

  def self.counter
    @@counter
  end

  def self.counter_two
    @@counter_two
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
    # puts self
    count_pulse

    dest = modules[dest_module_name]
    if dest.nil?
      # puts 'dest is nil'
      return
    end

    # puts "#{dest_module_name}(#{modules[dest_module_name][:module_state]})"
    # puts "=> #{pulse_type}"
    # puts self if dest[:destination_module_names].include?('lv')
    case dest[:module_type]
    when 'Flip-flop'
      if pulse_type == :low
        if dest[:module_state] == :off
          dest[:module_state] = :on
          # puts "#{dest_module_name}(#{modules[dest_module_name][:module_state]})"
          dest[:destination_module_names].map do |destination_module_name|
            Pulse.new(:high, dest_module_name, destination_module_name)
          end
        else
          dest[:module_state] = :off
          # puts "#{dest_module_name}(#{modules[dest_module_name][:module_state]})"
          dest[:destination_module_names].map do |destination_module_name|
            Pulse.new(:low, dest_module_name, destination_module_name)
          end
        end
      else
        # puts ':skip'
      end
    when 'Conjunction'
      # puts "update state with #{source_module_name} => #{pulse_type}"
      dest[:module_state][source_module_name] = pulse_type
      # puts "#{dest_module_name}(#{modules[dest_module_name][:module_state]})"
      generate_pulse_type = dest[:module_state].values.all?(:high) ? :low : :high
      dest[:destination_module_names].map do |destination_module_name|
        ret = Pulse.new(generate_pulse_type, dest_module_name, destination_module_name)
        if destination_module_name.include?('lv')
          # pp dest_module_name
          # pp destination_module_name
          @@counter_two[dest_module_name.to_sym][generate_pulse_type] += 1
          raise dest_module_name if generate_pulse_type == :high
        end
        # puts "generated #{ret}"
        ret
      end
    when 'broadcaster'
      # puts 'broadcaster'
      dest[:destination_module_names].map do |destination_module_name|
        Pulse.new(pulse_type, dest_module_name, destination_module_name)
      end
    when 'output'
      dest[:module_state] = :high if pulse_type == :low
      nil
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

  execution_loops = 1000

  execution_loops.times do |i|
    press_button

    resolve_pulses

    puts_debug_message("Round #{i + 1}", value: Pulse.counter)
  end

  Pulse.counter.values.reduce(&:*)
end

def solution_two(input_data)
  target = 'rx'
  @modules[target] = {
    destination_module_names: [],
    module_type: 'output',
    module_state: :low
  }

  sub_target = %w[hh tn st dt]
  found_sub_target = {
    hh: 3769,
    tn: 3863,
    st: 3929,
    dt: 4079
  }

  # => answer is found_sub_target.values.reduce(1, :lcm)

  parse(input_data)

  Pulse.load_modules(@modules)

  (1..).each do |i|
    break if i > 10_000

    sub_target.each do |sub_target_name|
      # puts "sub_target_name: #{sub_target_name}"
      # puts "@modules[sub_target_name][:module_state]: #{@modules[sub_target_name][:module_state]}"
      # next unless @modules[sub_target_name][:module_state].values.all?(:low)

      # puts "found #{sub_target_name}!"
      # puts "Round #{i}"
      # raise sub_target_name
    end

    if @modules[target][:module_state] == :high
      puts 'found!'
      puts "Round #{i}"
      break
    end

    press_button

    begin
      resolve_pulses
    rescue RuntimeError => e
      if sub_target.include? e.message
        puts "found #{e.message}!"
        puts "Round #{i}"
        raise 1
      end
    end

    if (i % 1000).zero?
      puts "Round #{i}"
      pp Pulse.counter_two
    end
  end

  nil

  # Pulse.counter.values.reduce(&:*)
end

#
#
### build methods

def parse(input_data)
  node_parents = {}

  @modules['button'] = {
    destination_module_names: ['broadcaster'],
    module_type: 'button',
    module_state: :low
  }

  # build modules and count parents
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
      module_state: (:off if module_name.start_with?('%') || module_name == 'broadcaster')
    }
  end

  # initialize module_state for conjunction modules
  @modules.select { |_k, v| v[:module_type] == 'Conjunction' }.each do |k, v|
    v[:module_state] = node_parents[k].each_with_object({}) { |n, hash| hash[n] = :low }
  end
end

def press_button
  # send pulses from broadcaster to its destination modules
  @pulses << [Pulse.new(:low, 'button', 'broadcaster')]
end

def resolve_pulses
  # resolve pulses from destination modules to their destination modules
  while @pulses.any?
    current_pulses = @pulses.shift
    current_pulses.each do |pulse|
      ret = pulse.resolve
      @pulses << ret unless ret.nil?
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
