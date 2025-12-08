sample_file = './sample.txt'
puzzle_file = './input.txt'

# puzzle is a 3d position with its coordinates
# part1 : C(1000, 2) -> sort -> union -> take 3 large group

Point = Data.define(:x, :y, :z) do
  def distance_to(other_point)
    unless other_point.is_a?(Point)
      raise ArgumentError, "Not a Point"
    end

    dx = self.x - other_point.x
    dy = self.y - other_point.y
    dz = self.z - other_point.z

    Math.sqrt(dx**2 + dy**2 + dz**2)
  end
end

Distance = Data.define(:point1, :point2, :value) do
  def self.between(p1, p2)
    calculated_value = p1.distance_to(p2)
    new(point1: p1, point2: p2, value: calculated_value)
  end
end

def group_connected_points(distances)
  graph = Hash.new { |hash, key| hash[key] = Set.new }
  distances.each do |d|
    graph[d.point1] << d.point2
    graph[d.point2] << d.point1
  end

  visited = Set.new
  groups = []

  graph.keys.each do |point|
    next if visited.include?(point)

    # DFS
    current_group = Set.new
    stack = [point]

    while !stack.empty?
      node = stack.pop
      next if visited.include?(node)

      visited << node
      current_group << node

      graph[node].each do |neighbor|
        stack.push(neighbor) unless visited.include?(neighbor)
      end
    end

    groups << current_group.to_a
  end

  groups
end

def solution_one(filename, pairs=10)
  # how to parse input
  # readline -> 2d array -> prepare how tachyon beam walks
  puts 'run part 1'
  puts filename
  data = File.readlines(filename, chomp: true)
  arr = data.map do |line|
    x, y, z = line.split(',').map(&:to_i)
    Point.new x:, y:, z:
  end

  ret = arr.combination(2)
           .map { |p1, p2| Distance.between(p1, p2) }
           .sort_by(&:value)
           .first(pairs)
           .then { group_connected_points(_1) }
           .map(&:count)
           .max(3)
           .inject('*')
  # pp arr
  # ret = 0

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file, 1000)

def solution_two(filename)
  puts 'run part 2'
  puts filename
  data = File.readlines(filename, chomp: true)

  # add boundary
  arr = data.map(&:chars).map { |line| ['b'] + line + ['b'] }
  arr.push(arr[0].size.times.map { 'b' })

  arr.each.with_index do |line, row|
    line.each.with_index do |_val, col|
      process!([row, col], arr)
    end
  end

  ret = 0

  arr.reverse!
  arr.each.with_index do |line, row|
    line.each_index do |col|
      case arr[row][col]
      when 'b', '.'
        next
      when '|'
        arr[row][col] = arr[row - 1][col].to_i.nonzero? || 1
      when '^'
        arr[row][col] = arr[row - 1][col - 1] + arr[row - 1][col + 1]
      when 'S'
        ret = arr[row - 1][col]
        break
      end
    end
  end

  # arr.each { |l| puts l.join("\t") }

  puts "answer: #{ret}"
end

# solution_two(sample_file)
# solution_two(puzzle_file)
