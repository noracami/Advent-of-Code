sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

class Solution1
  def initialize(input)
    case input
    when File
      @data = input.readlines.map(&:strip)
    when String, Array
      @data = input
    end
  end

  def area(env)
    case env
    when :sample
      @tall = 7
      @wide = 11
    when :puzzle
      @tall = 103
      @wide = 101
    end
    self
  end

  def parse_input
    # p=73,39 v=-17,38
    regexp = /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/
    ret = @data.map do |line|
      m = line.match(regexp)
      {
        x: m[1].to_i,
        y: m[2].to_i,
        dx: m[3].to_i,
        dy: m[4].to_i
      }
    end
    @drones = ret
  end

  def tick
    @drones.each do |drone|
      drone[:x] += drone[:dx]
      drone[:x] %= @wide
      drone[:y] += drone[:dy]
      drone[:y] %= @tall
    end
    self
  end

  def print_input
    puts "Input: #{@data}"
  end

  def print_drones
    # @drones.each do |drone|
    #   puts "Drone: #{drone}"
    # end
    board = Array.new(@tall) { Array.new(@wide, '.') }
    @drones.each do |drone|
      if board[drone[:y]][drone[:x]] == '.'
        board[drone[:y]][drone[:x]] = 1
      else
        board[drone[:y]][drone[:x]] += 1
      end
    end

    board.each do |row|
      puts row.map { |c| c == '.' ? '.' : c }.join
    end

    puts '---------------------------------'
  end

  def count_drones_of_each_quadrant
    # the x axis and y axis are not counted

    ret = { q1: 0, q2: 0, q3: 0, q4: 0 }
    diff = { dx: @wide / 2, dy: @tall / 2 }
    @drones.each do |drone|
      if drone[:x] < diff[:dx] && drone[:y] < diff[:dy]
        ret[:q1] += 1
      elsif drone[:x] > diff[:dx] && drone[:y] < diff[:dy]
        ret[:q2] += 1
      elsif drone[:x] < diff[:dx] && drone[:y] > diff[:dy]
        ret[:q3] += 1
      elsif drone[:x] > diff[:dx] && drone[:y] > diff[:dy]
        ret[:q4] += 1
      end
    end

    puts "Q1: #{ret[:q1]}, Q2: #{ret[:q2]}, Q3: #{ret[:q3]}, Q4: #{ret[:q4]}"

    ret
  end

  def solve(part2: false)
    parse_input
    # print_input
    # print_drones
    @counter = 0
    7280.times { tick }
    @counter += 7280
    while part2 || @counter < 100
      tick
      # print_drones
      next unless part2

      puts "Counter: #{@counter}" if (@counter % 20).zero?

      if clustering
        puts "found Easter Egg at #{@counter}"
        print_drones # print the last state
        break
      end

      @counter += 1
    end

    if part2
      puts "Counter: #{@counter}"
      return
    end

    print_drones

    drones = count_drones_of_each_quadrant

    # if part2
    #   clustering

    #   return
    # end

    puts "Answer: #{drones.values.reduce(:*)}"
  end
end

# Solution1.new(File.open(sample_file)).area(:sample).solve
# Solution1.new(File.open(puzzle_file)).area(:puzzle).solve

class QuickUnion
  attr_reader :count

  def initialize(size)
    @ids = (0..size - 1).to_a
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

class Solution2 < Solution1
  def solve
    super(part2: true)
  end

  def threshold(value)
    @threshold = value
    self
  end

  def clustering
    @uf = QuickUnion.new(@drones.size)

    @drones.each_with_index do |drone, i|
      @drones.each_with_index do |other_drone, j|
        next if i == j

        diff_x = (drone[:x] - other_drone[:x]).abs
        diff_y = (drone[:y] - other_drone[:y]).abs
        @uf.union(i, j) if diff_x + diff_y <= 1
      end
    end

    # puts "Clusters: #{@uf.count}"
    # puts each cluster
    clusters = {}
    @drones.each_with_index do |_drone, i|
      root = @uf.find(i)
      if clusters[root].nil?
        clusters[root] = [i]
      else
        clusters[root] << i
      end
    end

    # clusters.each do |root, cluster|
    #   puts "Cluster: #{cluster}"
    # end

    # is any cluster size bigger than threshold?
    # threshold = 4
    @threshold ||= 10
    big_clusters = clusters.select { |_, cluster| cluster.size >= @threshold }
    # puts "Big clusters: #{big_clusters.size}"

    big_clusters.any?
  end
end

# Solution2.new(File.open(sample_file)).area(:sample).solve
Solution2.new(File.open(puzzle_file)).area(:puzzle).threshold(20).solve
