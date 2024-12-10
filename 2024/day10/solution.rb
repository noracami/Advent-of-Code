sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

class Solution1
  def initialize(input)
    case input
    when File
      @data = input.readlines.map(&:strip)
    end
  end

  def construct_map
    @hash_map = {}
    ret = @data.map.with_index(1) do |line, row|
      line.each_char.map.with_index(1) do |char, col|
        @hash_map[char.to_i] ||= []
        @hash_map[char.to_i] << [row, col]
        @hash_map[[row, col]] = char.to_i
        # char.to_i
      end
    end

    # build boundary
    boundary = '+'
    ret.unshift([boundary] * ret.first.size)
    ret.push([boundary] * ret.first.size)
    ret.each do |line|
      line.unshift(boundary)
      line.push(boundary)
    end

    ret
  end

  def find_9
    @map ||= construct_map
    @hash_map[9]
  end

  def print_input
    puts 'Input:'
    @data.each do |line|
      puts line
    end
  end

  def print_map
    puts 'Map:'
    @map ||= construct_map
    @map.each do |line|
      puts line.join
    end
  end

  def bfs(start, target, consider_distinct_hiking_trails:)
    queue = [start]
    visited = [start]
    parent = {}
    founds = []

    while queue.any? # && !found
      current = queue.shift
      if target == @hash_map[current]
        founds << current
        # break
      end

      # add neighbors to queue
      neighbors = [
        [current[0] - 1, current[1]],
        [current[0] + 1, current[1]],
        [current[0], current[1] - 1],
        [current[0], current[1] + 1]
      ]
      # pp neighbors
      # pp(neighbors.map { |n| @hash_map[n] })
      neighbors.each do |neighbor|
        next if visited.include?(neighbor) && !consider_distinct_hiking_trails
        next if @hash_map[neighbor].nil?

        # # constraint: current - neighbor must be 1
        # puts "current: #{current}, neighbor: #{neighbor}"
        # puts "current: #{@hash_map[current]}, neighbor: #{@hash_map[neighbor]}"
        next if @hash_map[current] - @hash_map[neighbor] != 1

        # puts '----------------- test -----------------'
        # pp "parent: #{parent}"
        # puts "current: #{current}, neighbor: #{neighbor}"
        # puts '----------------- test end -------------'

        visited << neighbor
        parent[neighbor] = current
        queue << neighbor
      end
    end

    # puts '-----------------'
    # puts 'while loop ended'
    # puts '-----------------'

    return [] unless founds.any?

    founds

    # path = []
    # current = found
    # @counter = 0
    # while current != start && @counter < 10
    #   @counter += 1
    #   path.unshift(current)
    #   current = parent[current]
    # end
    # path.unshift(start)

    # path
  end

  def solve(consider_distinct_hiking_trails: false)
    print_input
    print_map

    start_points = find_9
    pp "Start points: #{start_points}"

    ret = 0
    start_points.each do |node|
      founds = bfs(node, 0, consider_distinct_hiking_trails:)
      next if founds.empty?

      score = founds.size

      puts "Node: #{node} has score: #{score}"
      ret += score
      # puts "Node: #{node} is connected to 0"
      # puts "Path from #{node} to 0: #{path}"
    end

    puts "\nResult: #{ret}"
  end
end

Solution1.new(File.open(sample_file)).solve
# Solution1.new(File.open(puzzle_file)).solve

class Solution2 < Solution1
  def solve
    super(consider_distinct_hiking_trails: true)
  end
end

Solution2.new(File.open(sample_file)).solve
# Solution2.new(File.open(puzzle_file)).solve
