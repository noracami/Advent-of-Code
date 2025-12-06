sample_file = './sample.txt'
puzzle_file = './input.txt'

def solution_one(filename)
  # how to parse input
  # readline -> split(' ') -> reject if ' ' -> transpose
  puts 'run part 1'
  puts filename
  data = File.readlines(filename, chomp: true)

  arr = data.map { |line| line.split.reject(&:empty?) }

  ret = 0
  arr.transpose.each do |question|
    op = question.pop
    ret += question.map(&:to_i).reduce(op)
  end

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  # how to parse input
  # readline -> save all char -> transpose -> reject if all ' '
  puts 'run part 2'
  puts filename
  data = File.readlines(filename, chomp: true)

  arr = data.map { |line| line.split.reject(&:empty?) }

  ret = 0
  arr.transpose.each do |question|
    op = question.pop
    ret += question.map(&:to_i).reduce(op)
  end

  puts "answer: #{ret}"
end

# solution_two(sample_file)
# solution_two(puzzle_file)
