sample_file = './sample.txt'
puzzle_file = './input.txt'

def solution_one(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  start = 50

  steps = data.map do |line|
    direction, len = line[0], line[1..].to_i
    direction == 'L' ? -1 * len : len
  end

  ret = 0
  steps.each do |n|
    start += n
    ret += 1 if (start % 100 == 0)
  end

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  start = 50

  steps = data.map do |line|
    direction, len = line[0], line[1..].to_i
    direction == 'L' ? -1 * len : len
  end

  ret = 0
  steps.each do |n|
    next if n.zero?

    # print "#{n.positive? ? 'R' : 'L'}#{n.abs}\tn= #{n}\t"

    q1 = n.abs.div 100
    ret += q1

    n1 = 0

    if n.positive?
      n1 = n - 100 * q1
    else
      n1 = n + 100 * q1
    end

    s1 = start + n1

    if s1.zero? || s1.abs >= 100 || s1 * start < 0
      ret += 1
    end

    start = s1 % 100

    # puts "start now = #{start}, ret now = #{ret}"
  end

  puts "answer: #{ret}"
end

solution_two(sample_file)
solution_two(puzzle_file)
