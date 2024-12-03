sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

def solution_one(filename, input = nil)
  puts 'using input' if input
  puts filename
  data = input || File.readlines(filename, chomp: true)
  # the input is a big string
  # scan the string for the target
  targets = data.flat_map { _1.scan(/mul\(\d+\,\d+\)/) }

  ret = 0

  # puts targets
  targets.each do |target|
    a, b = target.scan(/\d+/).map(&:to_i)
    ret += a * b
  end

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  data = [data.sum('')]

  data = data.map do |line|
    line_sub = line.dup.gsub(/don\'t\(\).+?do\(\)/, '')
    while line_sub.size != line.size
      line = line_sub
      line_sub = line.dup.gsub(/don\'t\(\).+?do\(\)/, '')
    end
    line_sub
  end

  solution_one(nil, data)
end

sample2_file = File.join(File.dirname(__FILE__), 'sample2.txt')

solution_two(sample2_file)
solution_two(puzzle_file)
