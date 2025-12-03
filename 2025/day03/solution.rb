sample_file = './sample.txt'
puzzle_file = './input.txt'

def solution_one(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  ret = 0
  last_index = data[0].size - 1

  # 1315
  # 1353
  data.each do |line|
    candidate1 = candidate2 = 0
    max_number = line.each_char.max
    max_number_except_last = line[0, last_index].each_char.max
    tmp = 0
    if line.index(max_number) == last_index
      # puts "a"
      tmp = "#{max_number_except_last}#{max_number}".to_i
    else
      # puts "b"
      tmp = "#{max_number}#{line[line.index(max_number) + 1, last_index].each_char.max}".to_i
    end
    # puts "tmp: #{tmp}"
    ret += tmp
  end

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  ret = 0
  last_index = data[0].size - 1

  # 1315
  # 1353
  data.each do |line|
    candidate1 = candidate2 = 0
    max_number = line.each_char.max
    max_number_except_last = line[0, last_index].each_char.max
    tmp = 0
    if line.index(max_number) == last_index
      # puts "a"
      tmp = "#{max_number_except_last}#{max_number}".to_i
    else
      # puts "b"
      tmp = "#{max_number}#{line[line.index(max_number) + 1, last_index].each_char.max}".to_i
    end
    # puts "tmp: #{tmp}"
    ret += tmp
  end

  puts "answer: #{ret}"
end

# solution_two(sample_file)
# solution_two(puzzle_file)
