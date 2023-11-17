# frozen_string_literal: true

print('select day: ')
input = $stdin.gets.chomp

if require "./day#{input}"
  Solution.show
else
  puts "can't find"
end
