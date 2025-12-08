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

# Disjoint Set (Union-Find)
class DisjointSet
  def initialize(points)
    @parent = {}
    points.each { |p| @parent[p] = p }
  end

  def find(point)
    if @parent[point] == point
      point
    else
      @parent[point] = find(@parent[point])
      @parent[point]
    end
  end

  def union(point_a, point_b)
    root_a = find(point_a)
    root_b = find(point_b)

    unless root_a == root_b
      @parent[root_a] = root_b
      true
    else
      false
    end
  end
end

# Kruskal find MST
def find_minimum_spanning_tree(points)
  edges = []

  edges = points.combination(2)
                .map { |p1, p2| Distance.between(p1, p2) }
                .sort_by(&:value)

  dsu = DisjointSet.new(points)
  minimum_spanning_tree_edges = []
  total_distance = 0

  edges.each do |edge|
    p1 = edge.point1
    p2 = edge.point2
    distance = edge.value

    if dsu.union(p1, p2)
      minimum_spanning_tree_edges << edge
      total_distance += distance

      break if minimum_spanning_tree_edges.length == points.length - 1
    end
  end

  {
    total_distance: total_distance,
    edges: minimum_spanning_tree_edges
  }
end

def solution_two(filename)
  puts 'run part 2'
  puts filename
  data = File.readlines(filename, chomp: true)

  points = data.map do |line|
    x, y, z = line.split(',').map(&:to_i)
    Point.new x:, y:, z:
  end

  tree = find_minimum_spanning_tree(points)

  ret = tree[:edges].last.then { |edge| edge.point1.x * edge.point2.x }

  puts "answer: #{ret}"
end

solution_two(sample_file)
solution_two(puzzle_file)
