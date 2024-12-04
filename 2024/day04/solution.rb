sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

def solution_one(filename, input = nil)
  puts 'using input' if input
  puts filename
  data = input || File.readlines(filename, chomp: true)
  two_d_map = data.map { _1.chars }
  # find the target in 8 directions
  # given = (x, y)
  # directions = [
  #   [-1,  1], [0,  1], [1,  1],
  #   [-1,  0],          [1,  0],
  #   [-1, -1], [0, -1], [1, -1]
  # ]
  @global_2d_map = two_d_map
  @canvas = two_d_map.map { |row| row.map { '.' } }
  @memo = []
  def is_valid(origin_x, origin_y, directions, unit)
    cells = []
    unit.times do |i|
      row = @global_2d_map[origin_y + directions[1] * i]
      return false if row.nil? || origin_y + directions[1] * i < 0
      col = row[origin_x + directions[0] * i]
      return false if col.nil? || origin_x + directions[0] * i < 0

      cells << col
    end
    result = cells.join == 'XMAS'
    if result
      @memo << [origin_x, origin_y, directions, unit]
      unit.times do |i|
        @canvas[origin_y + directions[1] * i][origin_x + directions[0] * i] = 'XMAS'[i]
      end
    end

    result
  end

  ret = 0

  eight_directions = [ [-1,  1], [0,  1], [1,  1], [-1,  0], [1,  0], [-1, -1], [0, -1], [1, -1] ]

  two_d_map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      eight_directions.each do |direction|
        ret += 1 if is_valid(x, y, direction, 4)
      end
    end
  end

  puts "answer: #{ret}"
  # puts @canvas.map(&:join)
  # puts @canvas.flatten.count('.')
  # puts @memo.map { |x, y, d, u| "#{x}, #{y}, #{d}, #{u}" }
end

# solution_one(sample_file)
# solution_one(puzzle_file)

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  @global_2d_map = data.map(&:chars)
  @canvas = @global_2d_map.map { |row| row.map { '.' } }

  def is_valid(origin_x, origin_y)
    if origin_x < 1 || origin_y < 1 || origin_x > @global_2d_map[0].size - 2 || origin_y > @global_2d_map.size - 2
      # puts "out of bound: #{origin_x}, #{origin_y}"
      return false
    end

    lines = []
    lines << @global_2d_map[origin_y - 1][origin_x - 1] + @global_2d_map[origin_y + 1][origin_x + 1]
    lines << @global_2d_map[origin_y - 1][origin_x + 1] + @global_2d_map[origin_y + 1][origin_x - 1]

    result = lines.all? { |line| line.count('M') == 1 && line.count('S') == 1 }
    # if origin_x == 2 && origin_y == 1
    #   puts "lines: #{lines}"
    #   puts "result: #{result}, #{origin_x}, #{origin_y}"
    # end

    # if result
    #   @canvas[origin_y - 1][origin_x - 1] = @global_2d_map[origin_y - 1][origin_x - 1]
    #   @canvas[origin_y + 1][origin_x - 1] = @global_2d_map[origin_y + 1][origin_x - 1]
    #   @canvas[origin_y - 1][origin_x + 1] = @global_2d_map[origin_y - 1][origin_x + 1]
    #   @canvas[origin_y + 1][origin_x + 1] = @global_2d_map[origin_y + 1][origin_x + 1]
    #   @canvas[origin_y][origin_x] = @global_2d_map[origin_y][origin_x]
    # end

    result
  end

  ret = 0

  @global_2d_map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      ret += 1 if cell == 'A' && is_valid(x, y)
    end
  end

  puts "answer: #{ret}"
  # puts @canvas.map(&:join)
end

# sample2_file = File.join(File.dirname(__FILE__), 'sample2.txt')

solution_two(sample_file)
solution_two(puzzle_file)
