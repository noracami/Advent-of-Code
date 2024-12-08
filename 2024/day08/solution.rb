sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

class Map
  def initialize
    @grids = []
    @antennas = {}
  end

  attr_accessor :grids, :antennas

  def to_s
    grids.map { _1.map(&:char).join }.join("\n")
  end

  def print_antinodes_with_map
    ret = 0
    str = grids.map do |row|
      row.map do |cell|
        if cell.has_antinode
          ret += 1
          'X'
        else
          cell.char
        end
      end.join
    end.join("\n")
    puts str

    ret
  end

  def construct_map(data)
    data.each.with_index do |line, row|
      line.each_char.with_index do |char, col|
        # do something
        grids[row] ||= []
        grids[row][col] = Struct.new(:char, :has_antinode).new(char, false)

        if char != '.'
          antennas[char] ||= []
          antennas[char] << [row, col]
        end
      end
    end
  end

  def make_antinodes(consider_resonant_harmonics = false)
    ret = {}
    antennas.each_value do |coords|
      coords.combination(2).each do |(r1, c1), (r2, c2)|
        if consider_resonant_harmonics
          ret[[r1, c1]] = true
          ret[[r2, c2]] = true
        end
        diff = [r1 - r2, c1 - c2]
        forward = [r1 + diff[0], c1 + diff[1]]
        backward = [r2 - diff[0], c2 - diff[1]]
        if forward[0] >= 0 && forward[0] < grids.size && forward[1] >= 0 && forward[1] < grids[0].size
          ret[forward] = true
          if consider_resonant_harmonics
            while forward[0] >= 0 && forward[0] < grids.size && forward[1] >= 0 && forward[1] < grids[0].size
              ret[forward] = true
              forward = [forward[0] + diff[0], forward[1] + diff[1]]
            end
          end
        end

        next unless backward[0] >= 0 && backward[0] < grids.size && backward[1] >= 0 && backward[1] < grids[0].size

        ret[backward] = true
        next unless consider_resonant_harmonics

        while backward[0] >= 0 && backward[0] < grids.size && backward[1] >= 0 && backward[1] < grids[0].size
          ret[backward] = true
          backward = [backward[0] - diff[0], backward[1] - diff[1]]
        end
      end
    end
    ret.each_key do |r, c|
      grids[r][c].has_antinode = true
    end
  end
end

class Solution1
  def initialize(input)
    case input
    when File
      @data = input.readlines.map(&:strip)
    end
  end

  def solve(params = {})
    the_map = Map.new
    the_map.construct_map(@data)
    the_map.make_antinodes(params[:consider_resonant_harmonics])

    puts the_map.antennas
    puts the_map
    ret = the_map.print_antinodes_with_map

    puts "Result: #{ret}"
  end
end

Solution1.new(File.open(sample_file)).solve
Solution1.new(File.open(puzzle_file)).solve

class Solution2 < Solution1
  def solve
    super(consider_resonant_harmonics: true)
  end
end

Solution2.new(File.open(sample_file)).solve
Solution2.new(File.open(puzzle_file)).solve
