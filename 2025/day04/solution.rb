sample_file = './sample.txt'
puzzle_file = './input.txt'

# create 2d array
# iterate row -> col
# the grid's value is how many neighbor next to it
# strategy: add 1 for every neighbor grid
# ---
# part2
# keep remove those removable rolls of paper

def neighbor_index(r, c)
  [
    [r - 1, c - 1], [r - 1, c], [r - 1, c + 1],
    [r,     c - 1], nil, [r, c + 1],
    [r + 1, c - 1], [r + 1, c], [r + 1, c + 1]
  ].compact
end

# input: current map of rolls of paper
# output: mark 'x' for removable rolls
# TODO: Follow up: can keep counts and abstract neighbor to reduce time of setup map from blank one
def map_of_removable_rolls_of_paper(source, rows, cols)
  tmp = rows.times.map { cols.times.map { 0 } }
  source.each.with_index do |line, row_index|
    line.each.with_index do |grid, column_index|
      next if grid != '@'

      neighbor_index(row_index + 1, column_index + 1).each { |r, c| tmp[r][c] += 1 }
    end
  end

  check = tmp.map { |x| x.map(&:itself) }
  source.each.with_index do |line, row_index|
    line.each.with_index do |grid, column_index|
      check[row_index + 1][column_index + 1] = (
        if grid != '@'
          '.'
        elsif tmp[row_index + 1][column_index + 1] < 4
          'x'
        else
          '@'
        end
      )
    end
  end

  check[1, rows - 2].map { _1[1, cols - 2] }
end

def solution_one(filename)
  puts 'run part 1'
  puts filename
  data = File.readlines(filename, chomp: true)

  # add boundary to easily avoid out-of-index error
  rows = data.size + 2
  cols = data[0].size + 2
  data = data.map { |r| r.each_char.to_a }
  ret = map_of_removable_rolls_of_paper(data, rows, cols).flatten.count('x')

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts 'run part 2'
  puts filename
  data = File.readlines(filename, chomp: true)

  # add boundary to easily avoid out-of-index error
  rows = data.size + 2
  cols = data[0].size + 2

  tmp = data.map { |r| r.each_char.to_a }
  result = -1
  ret = 0

  while result != 0
    # tmp.each { puts _1.join(' ') }
    # puts '---'
    # pp result
    # sleep 2

    # remove those removable rolls of paper
    tmp = tmp.map { |r| r.map { |g| g == 'x' ? '.' : g } }
    tmp = map_of_removable_rolls_of_paper(tmp, rows, cols)
    result = tmp.flatten.count('x')
    ret += result
  end

  puts "answer: #{ret}"
end

solution_two(sample_file)
solution_two(puzzle_file)
