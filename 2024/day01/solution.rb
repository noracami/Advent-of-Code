sample_file = './sample.txt'
puzzle_file = './input.txt'

def solution_one(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  left = []
  right = []
  data.each do |line|
    a, b = line.split('  ').map(&:to_i)
    left << a
    right << b
  end
  left.sort!
  right.sort!
  ret = 0
  while left.any?
    a = left.shift
    b = right.shift
    ret += (a - b).abs
  end

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  left = []
  right = []
  data.each do |line|
    a, b = line.split('  ').map(&:to_i)
    left << a
    right << b
  end
  left = left.tally
  right = right.tally
  ret = 0
  left.each do |k, v|
    ret += k * v * right[k].to_i
  end

  puts "answer: #{ret}"
end

solution_two(sample_file)
solution_two(puzzle_file)
