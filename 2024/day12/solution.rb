sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

class QuickFind
  def initialize(size)
    @ids = (0..size-1).to_a
  end

  def find(index)
    @ids[index]
  end

  def connected?(p, q)
    find(p) == find(q)
  end

  def union(p, q)
    return if connected?(p, q)

    old = @ids[p]
    new = @ids[q]

    @ids.map! { |val| val = (val == old)? new : val }
  end

  def count
    @ids.uniq.size
  end
end

class QuickUnion
  attr_reader :count

  def initialize(size)
    @ids = (0..size-1).to_a
    @count = size
  end

  def find(index)
    @ids[index] == index ? index : find(@ids[index])
  end

  def connected?(p, q)
    find(p) == find(q)
  end

  def union(p, q)
    return if connected?(p, q)

    @ids[find(p)] = find(q)
    @count -= 1
  end
end

class Solution1
  def initialize(input)
    case input
    when File
      @data = input.readlines.map(&:strip)
    when String, Array
      @data = input
    end
  end

  def print_input
    puts "Input: #{@data}"
  end

  def print_answer
    puts "Result: #{@answer.values.sum}\n\n"
  end

  def print_board
    @board.nil? && build_the_board

    rows = @data.size + 1
    cols = @data[0].size + 2

    arr = (0..rows).map { |i| (0..cols).map { |j| @board[[i, j]] } }
    arr.each do |line|
      puts line.join
    end
  end

  def print_regions
    ret = 0
    @regions.each do |char, cells|
      borders = count_the_region_perimeter(cells)
      price = cells.size * borders
      # puts "Region #{char}: #{cells.size}\t*#{borders} = #{price}"

      ret += price unless char.start_with?('-')
    end

    puts "\n\n\nTotal: #{ret}"
  end

  def build_the_board
    @board = @data.each_with_object({}).with_index(1) do |(line, board), row|
      line.each_char.with_index(1) do |char, col|
        board[[row, col]] = char
      end
    end
    # add boundaries to the board for easier detect out of bounds
    rows = @data.size
    cols = @data[0].size + 2
    0.upto(rows) { |col|
      @board[[0, col]] = '-'
      @board[[rows + 1, col]] = '-'
    }
    0.upto(cols) { |row|
      @board[[row, 0]] = '-'
      @board[[row, cols]] = '-'
    }
  end

  # # to build the region including the cell
  # def bfs(cell, visited)
  #   queue = [cell]
  #   char = @board[cell]
  #   key = "#{char}_#{cell.to_s}"
  #   @regions[key] ||= Set.new
  #   while queue.any?
  #     current = queue.shift

  #     visited[current] = true
  #     @regions[key] << current
  #     # check the neighbors
  #     neighbors = [
  #       [current[0] - 1, current[1]],
  #       [current[0] + 1, current[1]],
  #       [current[0], current[1] - 1],
  #       [current[0], current[1] + 1]
  #     ]
  #     neighbors.each do |neighbor|
  #       next if @board[neighbor] != char
  #       next if visited[neighbor]

  #       queue << neighbor
  #     end
  #   end
  # end
  def union_the_region
    @regions = {}
    # visited = Hash.new(false)
    grids = @data.map { |line| line.chars }
    # puts "rows: #{grids.size}, cols: #{grids[0].size}"
    # raise 'err'
    ds = QuickUnion.new(grids.size * grids[0].size)
    grids.each_with_index do |line, row|
      line.each_with_index do |char, col|
        id = row * line.size + col
        neighbors = [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]]

        neighbors.each do |neighbor|
          next if neighbor[0] < 0 || neighbor[0] >= grids.size
          next if neighbor[1] < 0 || neighbor[1] >= line.size

          neighbor_id = neighbor[0] * line.size + neighbor[1]

          next if ds.connected?(id, neighbor_id)

          letter = grids[neighbor[0]][neighbor[1]]
          if letter == char
            # puts "Union #{id}(#{char}[#{row}, #{col}]) and #{neighbor_id}(#{letter}[#{neighbor[0]}, #{neighbor[1]})"

            ds.union(id, neighbor_id)
            # puts "Count: #{ds.count}"
          end
        end
      end
    end

    pp ds
    pp ds.count


    puts "done.\n\n\n"

    raise 'Not implemented'


      # next if visited[cell]
      # puts "Start from #{cell}" if char != '-'
      # bfs(cell, visited)
      # puts "done." if char != '-'

  end

  def count_the_region
    union_the_region
    # @regions = {}
    # visited = Hash.new(false)
    # @board.each do |cell, char|
    #   next if visited[cell]
    #   puts "Start from #{cell}" if char != '-'
    #   bfs(cell, visited)
    #   puts "done." if char != '-'
    # end
  end

  def count_the_region_perimeter(cells, verbose: false)
    # sample:
    # RRRR
    # RRRR
    # VVRRR
    # VVR
    # ---
    # from top to bottom for each column
    #   count how many distinct groups
    #   borders = 2 * groups
    # from left to right for each row
    #   count how many distinct groups
    #   borders = 2 * groups
    borders = 0
    columns = cells.group_by { |cell| cell[1] }.map { |col, cells| [col, cells.sort] }.to_h
    puts "columns: #{columns}" if verbose
    rows = cells.group_by { |cell| cell[0] }.map { |row, cells| [row, cells.sort] }.to_h
    groups_count_by_columns = 0
    columns.each do |col, cells|
      puts "**** #{cells.slice_when { |cell1, cell2| cell2[0] - cell1[0] != 1 }.to_a}" if verbose
      groups_count_by_columns += cells.slice_when { |cell1, cell2| cell2[0] - cell1[0] != 1 }.to_a.size
    end
    border_provided_from_columns = 2 * groups_count_by_columns
    puts "  borders from columns\t: #{border_provided_from_columns}" if verbose
    groups_count_by_rows = 0
    rows.each do |row, cells|
      print "++++ #{cells.slice_when { |cell1, cell2| cell2[1] - cell1[1] != 1 }.to_a}" if verbose
      puts ": #{cells.slice_when { |cell1, cell2| cell2[1] - cell1[1] != 1 }.to_a.size}" if verbose
      groups_count_by_rows += cells.slice_when { |cell1, cell2| cell2[1] - cell1[1] != 1 }.to_a.size
    end
    border_provided_from_rows = 2 * groups_count_by_rows
    puts "  borders from rows\t: #{border_provided_from_rows}" if verbose

    borders = border_provided_from_columns + border_provided_from_rows
    puts "  borders \t\t: #{borders}" if verbose
    borders
  end

  def solve
    print_input
    print_board
    count_the_region
    print_regions

    # raise 'Blink times not set' unless @blink_times

    # @blink_times.times { blink }

    # print_answer
  end
end

Solution1.new(File.open(sample_file)).solve
Solution1.new(File.open(puzzle_file)).solve

# class Solution2 < Solution1
#   def solve
#     set_blink_times(75)
#     super
#   end
# end

# # Solution2.new(File.open(sample_file)).solve
# Solution2.new(File.open(puzzle_file)).solve
# # Solution2.new('0').solve
