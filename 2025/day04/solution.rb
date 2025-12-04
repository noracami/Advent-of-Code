sample_file = './sample.txt'
puzzle_file = './input.txt'

# dp = [0]...[0] size = batteries
# how to find dp[0]'s value?
# n from 9 to 0, choose n if str.index(n) <= str.size - batteries + index else n -= 1
def dp(str, batteries, boundary=1000)
  res = []
  0.upto(batteries - 1).each do |i|
    # puts "#{i}: #{str}"
    9.downto(0) do |n|
      index_n = str.index(n.to_s)
      if index_n && index_n <= str.size - batteries + i
        res << n
        str = str[index_n + 1, boundary]
        break
      end
    end
  end

  res.join.to_i
end

# create 2d array
# iterate row -> col
# the grid's value is how many neighbor next to it
# strategy: add 1 for every neighbor grid

def neighbor_index(r, c)
  [
    [r - 1, c - 1], [r - 1, c], [r - 1, c + 1],
    [r,     c - 1],        nil, [r,     c + 1],
    [r + 1, c - 1], [r + 1, c], [r + 1, c + 1]
  ].compact
end

def solution_one(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  # add boundary to easily avoid out-of-index error
  rows = data.size + 2
  cols = data[0].size + 2

  map = rows.times.map { cols.times.map { 0 } }
  data.each.with_index do |line, row_index|
    line.each_char.with_index do |grid, column_index|
      if grid == '@'
        neighbor_index(row_index + 1, column_index + 1).each do |r, c|
          map[r][c] += 1
        end
      end
    end
  end

  # iterate the map again and query map to get neighbors
  ret = 0
  check = map.map { |x| x.map { |y| y } }
  data.each.with_index do |line, row_index|
    line.each_char.with_index do |grid, column_index|
      if grid == '@'
        if map[row_index + 1][column_index + 1] < 4
          ret += 1
          check[row_index + 1][column_index + 1] = 'x'
        else
          check[row_index + 1][column_index + 1] = '@'
        end
      else
        check[row_index + 1][column_index + 1] = '.'
      end
    end
  end

  # check.each  { puts _1.join(' ') }
  # puts "---"
  # map.each  { puts _1.join(' ') }
  # puts "---"
  puts "answer: #{ret}"
end

solution_one(sample_file) # == 357
solution_one(puzzle_file) # == 17405

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  ret = data.sum { |line| dp(line, 12) }

  puts "answer: #{ret}"
end

# solution_two(sample_file) # == 3121910778619
# solution_two(puzzle_file) # == 171990312704598
