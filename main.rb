# frozen_string_literal: true

print('select day: ')
input = $stdin.gets.chomp

if require "./day#{input}"
  puts('1) part1')
  print('2) part2 ')
  case $stdin.gets.chomp
  when '1'
    Solution.part1
  when '2'
    Solution.part2
  else
    puts 'not allow selection'
  end
else
  puts "can't find"
end
