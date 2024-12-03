sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

def solution_one(filename)
  puts filename
  data = File.readlines(filename, chomp: true)
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

# def solution_two(filename)
#   puts filename
#   data = File.readlines(filename, chomp: true)

#   ret = 0
#   data.each do |line|
#     line = line.split.map(&:to_i)
#     diffs = line.each_cons(2).map { |a, b| (a - b) }
#     if (
#       diffs.all?(&:positive?) || diffs.all?(&:negative?)
#     ) && (diffs.map(&:abs).all? { |n| n >= 1 && n <= 3 })
#       ret += 1
#       next
#     end

#     line_remove_one = line.each_index.map { |i| line.dup.tap { |l| l.delete_at(i) } }

#     line_remove_one.any? do |l|
#       new_diffs = l.each_cons(2).map { |a, b| (a - b) }
#       if (
#         new_diffs.all?(&:positive?) || new_diffs.all?(&:negative?)
#       ) && (new_diffs.map(&:abs).all? { |n| n >= 1 && n <= 3 })
#         ret += 1
#         break
#       end
#     end
#   end

#   puts "answer: #{ret}"
# end

# solution_two(sample_file)
# solution_two(puzzle_file)
