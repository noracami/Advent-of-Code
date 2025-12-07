sample_file = './sample.txt'
puzzle_file = './input.txt'

@counter = 0

# input: current grid [S / . / ^ / |]
# output: transform [-1,1], [0,1] and [1,1]
def process!(grid, puzzle)
  case puzzle[grid[0]][grid[1]]
  when '|', 'S'
    move!([grid[0] + 1, grid[1]], puzzle)
  end
end

def move!(grid, puzzle)
  case puzzle[grid[0]][grid[1]]
  when '.'
    puzzle[grid[0]][grid[1]] = '|'
  when '^'
    @counter += 1
    move!([grid[0] + 1, grid[1] - 1], puzzle)
    move!([grid[0] + 1, grid[1] + 1], puzzle)
  end
end

def solution_one(filename)
  # how to parse input
  # readline -> 2d array -> prepare how tachyon beam walks
  puts 'run part 1'
  puts filename
  data = File.readlines(filename, chomp: true)
  @counter = 0

  # add boundary
  arr = data.map(&:chars).map { |line| ['b'] + line + ['b'] }
  arr.push(arr[0].size.times.map { 'b' })

  arr.each.with_index do |line, row|
    line.each.with_index do |_val, col|
      process!([row, col], arr)
    end
  end

  ret = @counter

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts 'run part 2'
  puts filename
  data = File.readlines(filename, chomp: true)

  # add boundary
  arr = data.map(&:chars).map { |line| ['b'] + line + ['b'] }
  arr.push(arr[0].size.times.map { 'b' })

  arr.each.with_index do |line, row|
    line.each.with_index do |_val, col|
      process!([row, col], arr)
    end
  end

  ret = 0

  arr.reverse!
  arr.each.with_index do |line, row|
    line.each_index do |col|
      case arr[row][col]
      when 'b', '.'
        next
      when '|'
        arr[row][col] = arr[row - 1][col].to_i.nonzero? || 1
      when '^'
        arr[row][col] = arr[row - 1][col - 1] + arr[row - 1][col + 1]
      when 'S'
        ret = arr[row - 1][col]
        break
      end
    end
  end

  # arr.each { |l| puts l.join("\t") }

  puts "answer: #{ret}"
end

solution_two(sample_file)
solution_two(puzzle_file)
