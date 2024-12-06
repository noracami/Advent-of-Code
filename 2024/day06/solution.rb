sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

def solution_one(filename, input = nil)
  puts 'using input' if input
  puts filename unless input

  data = nil
  maps = []

  if input
    maps = input
  else
    data = File.readlines(filename, chomp: true)
    data.each.with_index(1) do |line, row|
      maps << []
      line.each_char.with_index(1) do |char, col|
        maps[-1] << [row, col, char]
      end
    end
  end

  # add 1 padding to the maps to avoid the out of index error
  maps.unshift(Array.new(maps[0].size, []))
  maps[0].size.times { |i| maps[0][i] = [0, i, 'B'] }
  maps.push(Array.new(maps[0].size, []))
  maps[-1].size.times { |i| maps[-1][i] = [maps.size - 1, i, 'B'] }
  maps.each do |line|
    line.unshift([line[0][0], 0, 'B'])
    line.push([line[0][0], line.size - 1, 'B'])
  end

  # maps.push(Array.new(maps[0].size, 'B'))
  # maps.each do |line|
  #   line.unshift('B')
  #   line.push('B')
  # end

  # print the maps
  def print_maps(the_maps)
    the_maps.each do |line|
      line.each do |cell|
        print cell[2]
      end
      print "\n"
    end
  end
  # print_maps(maps)

  current_position = 0
  current_position = maps.find { |line| line.any? { |cell| cell[2] == '^' } }.find { |cell| cell[2] == '^' }
  puts "current_position: #{current_position}" unless input

  directions = {
    'N' => [-1, 0, 'E'],
    'E' => [0, 1, 'S'],
    'S' => [1, 0, 'W'],
    'W' => [0, -1, 'N']
  }
  current_direction = 'N'

  visited = {}
  visited["#{current_position[0]}-#{current_position[1]}"] = true
  visited_with_direction = {}
  visited_with_direction["#{current_position[0]}-#{current_position[1]}-#{current_direction}"] = true
  # visited["#{current_position[0]}-#{current_position[1]}-#{current_direction}"] = true

  # # debug
  # turn_count = 0

  # walk through the maps
  while current_position[2] != 'B'
    row, col, char = current_position
    new_row, new_col = row + directions[current_direction][0], col + directions[current_direction][1]
    new_char = maps[new_row][new_col][2]
    if new_char == '.' || new_char == '^'
      current_position = maps[new_row][new_col]

      # pp visited
      if visited_with_direction["#{new_row}-#{new_col}-#{current_direction}"]
        # meet the loop
        @has_loop = true
        break
      end

      visited["#{new_row}-#{new_col}"] = true
      visited_with_direction["#{new_row}-#{new_col}-#{current_direction}"] = true
      # # debug
      # maps[new_row][new_col][2] = 'v'

      next
    elsif new_char == '#'
      # # debug
      # turn_count += 1
      # if turn_count > 9
      #   break
      # end

      # turn right
      current_direction = directions[current_direction][2]
      next
    elsif new_char == 'B'
      # end of the maps
      break
    # elsif new_char == '^'
    #   # the start point
    #   current_position = maps[new_row][new_col]
    #   next
    else
      raise "unexpected char: #{new_char}"
    end
  end

  return 0 if @has_loop

  ret = visited.size
  puts "answer: #{ret}" unless input

  # # debug
  # print_maps(maps)
end

solution_one(sample_file)
solution_one(puzzle_file)

DIRECTIONS = {
  'N' => [-1, 0, 'E'],
  'E' => [0, 1, 'S'],
  'S' => [1, 0, 'W'],
  'W' => [0, -1, 'N']
}

def solution_two(filename)
end

# solution_two(sample_file)
# # solution_two(puzzle_file)
