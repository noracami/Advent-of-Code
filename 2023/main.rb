# frozen_string_literal: true

module AdventOfCodeFileIO
  def initialize(scope = nil)
    @day = self.class::DAY
    raise 'DAY not set' if @day.nil?

    @scope = scope
    @answer = case scope
              when 'part1' then solution_one(load_input_file(1))
              when 'part2' then solution_two(load_input_file(2))
              else raise 'accept one of <part1|part2>'
              end
  end

  def load_input_file(idx)
    file = "./#{day}/input.txt"
    if !File.file?(file) || self.class::READ_SAMPLE
      load_sample_file(idx)
    else
      File.readlines(file, chomp: true)
    end
  end

  def load_sample_file(idx)
    file = "./#{day}/sample-#{idx}.txt"
    file = "./#{day}/sample.txt" unless File.file?(file)

    puts 'use sample'

    puts data = File.readlines(file, chomp: true)

    data
  end

  def print_answers
    puts "=== #{scope} ==="
    puts answer
  end
end

print('select day: ')
input = $stdin.gets.chomp

if input.empty?
  require 'date'
  puts "today is: #{Date.today}"
  puts "use today: #{Date.today.day}"
  input = Date.today.day
end

# TODO: handle LoadError
puts "can't find day#{input}" && return unless require "./day#{input}/solution"

print("1) part1\n")
print("2) part2\n")
print('3) both   ')
case $stdin.gets.chomp
when '1'
  Solution.new('part1').print_answers
when '2'
  Solution.new('part2').print_answers
when '3'
  Solution.new('part1').print_answers
  Solution.new('part2').print_answers
else
  puts 'select part1 as default'
  Solution.new('part1').print_answers
end
