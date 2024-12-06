sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

DIRECTIONS = {
  'N' => [-1, 0, 'E'],
  'E' => [0, 1, 'S'],
  'S' => [1, 0, 'W'],
  'W' => [0, -1, 'N']
}.freeze

class Cell
  def initialize(params)
    @row = params.fetch(:row)
    @col = params.fetch(:col)
    @char = params.fetch(:char)
    @visited_count = params.fetch(:visited_count, 0)
    @last_direction = nil
  end

  attr_accessor :row, :col, :char, :visited_count, :last_direction

  def to_state
    {
      row: @row, col: @col, char: @char, visited_count: @visited_count, last_direction: @last_direction
    }
  end

  def load_state(state)
    @row = state[:row]
    @col = state[:col]
    @char = state[:char]
    @visited_count = state[:visited_count]
    @last_direction = state[:last_direction]
  end
end

class Map
  def initialize(params)
    @input = params.fetch(:input)
  end

  def build_map
    @content = @input.map(&:chars)
    # add padding
    @content.unshift(Array.new(@content[0].length, 'B'))
    @content.push(Array.new(@content[0].length, 'B'))
    @content.each do |line|
      line.unshift('B')
      line.push('B')
    end

    @content.map.with_index do |line, row|
      line.map.with_index do |char, col|
        @content[row][col] = Cell.new(row: row, col: col, char: char)
      end
    end
  end

  attr_accessor :content

  def print_map
    @content.each do |line|
      puts line.map(&:char).join
    end
  end

  def find_starting_point
    @content.each do |line|
      line.each do |cell|
        next unless cell.char == '^'

        cell.visited_count = 1
        cell.last_direction = 'N'
        @current = cell
        return cell
      end
    end

    nil
  end

  def walk
    current = find_starting_point

    while current
      next_cell = next_cell(current)
      return 1 if next_cell == :loop

      return 0 unless next_cell

      current = next_cell
    end
  end

  def step
    @current = next_cell(@current)
  end

  def next_cell(current)
    # pp "Current: #{current.row}, #{current.col}, #{current.char}, #{current.last_direction}"
    direction = current.last_direction
    row = current.row + DIRECTIONS[direction][0]
    col = current.col + DIRECTIONS[direction][1]

    # blocked
    if @content[row][col].char == '#' || @content[row][col].char == 'O'
      # turn right
      direction = DIRECTIONS[direction][2]
      row = current.row + DIRECTIONS[direction][0]
      col = current.col + DIRECTIONS[direction][1]
    end

    # comment: waste most of the time here ================================
    # if blocked again, turn right again
    if @content[row][col].char == '#' || @content[row][col].char == 'O'
      direction = DIRECTIONS[direction][2]
      row = current.row + DIRECTIONS[direction][0]
      col = current.col + DIRECTIONS[direction][1]
    end

    # out of bounds
    return nil if @content[row][col].char == 'B'

    # store visited
    @content[row][col].visited_count += 1
    @content[row][col].last_direction = direction

    # check for loop
    return :loop if @content[row][col].visited_count > 10

    @content[row][col]
  end

  def count_visited
    @content.flatten.select { |cell| cell.visited_count.positive? }.count
  end

  def set_cell(row, col, char)
    @content[row][col].char = char
  end

  def save
    # to save current state

    # pp "Current: #{@current}"
    @state = {
      content: @content.map { |line| line.map(&:to_state) },
      current_coordinates: [@current.row, @current.col]
    }
  end

  def load
    # to load previous state
    @content.each_with_index do |line, row|
      line.each_with_index do |cell, col|
        cell.load_state(@state[:content][row][col])
      end
    end

    @current = @content[@state[:current_coordinates][0]][@state[:current_coordinates][1]]
  end

  def visited_cells
    @content.flatten.select { |cell| cell.visited_count.positive? }
  end
end

def solution_one(filename, input = nil)
  puts "Solution One: #{filename}"

  input ||= File.open(filename).readlines.map(&:strip)

  map = Map.new(input: input)
  map.build_map

  start = map.find_starting_point

  puts "Start: #{start.row}, #{start.col}"

  # map.print_map

  map.walk

  puts "Visited: #{map.count_visited}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts "Solution Two: #{filename}"

  input = File.open(filename).readlines.map(&:strip)

  result = 0
  results = {}

  chars_input = input.map(&:chars)
  map = Map.new(input: chars_input.map(&:join))

  map.build_map
  map.find_starting_point
  map.save

  map.walk

  obstruction_candidates = map.visited_cells
  obstruction_candidates.each do |cell|
    map.load
    map.set_cell(cell.row, cell.col, '#')
    next unless map.walk == 1

    result += 1
    results[[cell.row, cell.col]] = true
    puts "Result: #{result}"
  end

  puts "Map: ======================\n\n"
  map = Map.new(input: input)
  map.build_map

  results.each_key do |key|
    next if map.content[key[0]][key[1]].char != '.'

    map.set_cell(key[0], key[1], 'O')
  end

  map.print_map
  puts "Result: #{result}"
end

solution_two(sample_file)
solution_two(puzzle_file)
