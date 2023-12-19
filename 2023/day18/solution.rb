# frozen_string_literal: true

require 'io/console'

class Solution
  include AdventOfCodeFileIO
  attr_reader :day, :answer, :scope

  DAY = 'day18'
  READ_SAMPLE = false

  def initialize(*)
    initialize_instance_variables

    super
  end
end

#
#
### build solution

def solution_one(input_data)
  parse(input_data).each { |direction, length, _color| scan(direction, length.to_i) }
  puts_debug_message(
    'boundary',
    value: "[#{@boundary_left}, #{@boundary_top}], [#{@boundary_right}, #{@boundary_bottom}]"
  )
  @blank_map = Array.new(@boundary_bottom - @boundary_top + 1) { Array.new(@boundary_right - @boundary_left + 1, '.') }

  initialize_instance_variables(row: -@boundary_top, col: -@boundary_left)

  parse(input_data).each { |direction, length, _color| walk(direction, length.to_i) }

  # tt = pp @blank_map.map(&:join)

  # puts tt

  # tt.chars.chunk_while { |a, b| a == b }.each do |chunk|
  #   pp chunk.first
  # end

  # @blank_map.map.with_index do |line, row|
  #   next if row > 5

  #   count_if_boundary_or_interior(line, row)
  # end.first 5

  # @another_map = [[]]

  @blank_map.map.with_index { |line, row| count_if_boundary_or_interior(line, row) }.last 3
  @blank_map.map.with_index { |line, row| count_if_boundary_or_interior(line, row) }.sum
end

def solution_two(input_data); end

#
#
### build methods

def parse(input_data)
  input_data.map(&:split)
end

def initialize_instance_variables(row: nil, col: nil)
  if row && col
    @current_row = row
    @current_col = col
    @boundary_left += col
    @boundary_right += col
    @boundary_top += row
    @boundary_bottom += row
  else
    @current_row = 0
    @current_col = 0
    @boundary_left = 0
    @boundary_right = 0
    @boundary_top = 0
    @boundary_bottom = 0
  end
end

def walk(direction, length)
  case direction
  when 'R'
    length.times { |i| mark_as_visited(@current_row, @current_col + i + 1) }
    @current_col += length
  when 'L'
    length.times { |i| mark_as_visited(@current_row, @current_col - i - 1) }
    @current_col -= length
  when 'U'
    length.times { |i| mark_as_visited(@current_row - i - 1, @current_col) }
    @current_row -= length
  when 'D'
    length.times { |i| mark_as_visited(@current_row + i + 1, @current_col) }
    @current_row += length
  end
end

def mark_as_visited(row, col)
  @blank_map[row][col] = '#'
end

def scan(direction, length)
  case direction
  when 'R' then @current_col += length
  when 'L' then @current_col -= length
  when 'U' then @current_row -= length
  when 'D' then @current_row += length
  end

  mark_boundary
end

def mark_boundary
  @boundary_left = @current_col if @current_col < @boundary_left
  @boundary_right = @current_col if @current_col > @boundary_right
  @boundary_top = @current_row if @current_row < @boundary_top
  @boundary_bottom = @current_row if @current_row > @boundary_bottom
end

def change_char_to_symbol(pattern)
  # print pattern
  # print ', '
  # pattern
  # 1.258
  #   .#.
  #   .#.
  #   .#.
  # 2.256
  #   .#.
  #   .##
  #   ...
  # 3.458
  #   ...
  #   ##.
  #   .#.
  # 4.245
  #   .#.
  #   ##.
  #   ...
  # 5.568
  #   ...
  #   .##
  #   .#.
  case pattern
  when '258'
    # :boundary
    :flip
  when '256'
    if @flag
      if @flag == :wait_256
        @flag = nil
        :flip
      else
        @flag = nil
        false
      end
    else
      @flag = :wait_458
    end
  when '458'
    if @flag
      if @flag == :wait_458
        @flag = nil
        :flip
      else
        @flag = nil
        false
      end
    else
      @flag = :wait_256
    end
  when '245'
    if @flag
      if @flag == :wait_245
        @flag = nil
        :flip
      else
        @flag = nil
        false
      end
    else
      @flag = :wait_568
    end
  when '568'
    if @flag
      if @flag == :wait_568
        @flag = nil
        :flip
      else
        @flag = nil
        false
      end
    else
      @flag = :wait_245
    end
  else
    raise "unknown pattern: #{pattern}"
  end
end

def count_if_boundary_or_interior(arr, row)
  is_interior = false
  counter = 0
  chunks = arr.zip(0..).chunk_while { |a, b| a.first == b.first }.to_a
  chunks.map do |chunk|
    if chunk.first.first == '.'
      unless is_interior
        # @another_map.last << chunk.first
        next
      end
    elsif chunk.size == 1
      is_interior = !is_interior
    else
      left_col = chunk.first.last
      right_col = chunk.last.last
      left = [row, left_col]
      right = [row, right_col]
      left_pattern = []
      left.then do |r, c|
        left_pattern << 2 if r > 0 && @blank_map[r - 1][c] == '#'
        left_pattern << 4 if c > 0 && @blank_map[r][c - 1] == '#'
        left_pattern << 5
        left_pattern << 6 if @blank_map[r][c + 1] == '#'
        left_pattern << 8 if r < @boundary_bottom && @blank_map[r + 1][c] == '#'
      end
      right_pattern = []
      right.then do |r, c|
        right_pattern << 2 if r > 0 && @blank_map[r - 1][c] == '#'
        right_pattern << 4 if c > 0 && @blank_map[r][c - 1] == '#'
        right_pattern << 5
        right_pattern << 6 if @blank_map[r][c + 1] == '#'
        right_pattern << 8 if r < @boundary_bottom && @blank_map[r + 1][c] == '#'
      end
      puts "\n\n\n"
      puts '[#{@boundary_left}, #{@boundary_top}], [#{@boundary_right}, #{@boundary_bottom}]'
      puts_debug_message(
        'boundary',
        value: "[#{@boundary_left}, #{@boundary_top}], [#{@boundary_right}, #{@boundary_bottom}]"
      )
      pp current_coordinate = { left:, right: }
      change_char_to_symbol(left_pattern.join)
      is_interior = !is_interior if change_char_to_symbol(right_pattern.join) == :flip
      # pp is_interior
      # puts "\n\n"
    end

    counter += chunk.size
  end

  counter
end

def puts_debug_message(key = nil, value:)
  puts "================ #{key} =================" if key
  puts value

  if block_given?
    yield
  elsif key
    puts ('=' * (key.size + 2)) + '=================================' + "\n\n"
  end
end
