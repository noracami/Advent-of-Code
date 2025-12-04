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

  def print_input
    puts "Input: #{@data}"
  end

  def parse_input
    @data = @data.slice_when { |i, _j| i.empty? }.map { |i| i.reject(&:empty?) }
    locks, keys = @data.partition { |i| i.first =~ /#####/ }

    @locks = locks.map { |lock| lock.map(&:chars).transpose.map { |r| r.count('#') } }
    @keys = keys.map { |key| key.map(&:chars).transpose.map { |r| r.count('.') } }
    # right_keys = @locks.map { |key| key.map { |value| 7 - value } }
    right_keys = @locks.map { |key| key.map(&:to_s).join.to_i }
    @right_keys = Set.new(right_keys)

    @locks = @locks.map { |lock| lock.map(&:to_s).join.to_i }
    @keys = @keys.map { |key| key.map(&:to_s).join.to_i }
  end

  def pretty_print
    # pp @data
    # pp @locks
    # pp @right_keys
    # pp @keys
    # @data.each do |row|
    #   puts row.join("\n")
    # end
  end

  def solve(part2: false)
    print_input
    parse_input
    pretty_print

    ret = 0

    pp "locks: #{@locks}"
    pp "keys: #{@keys}"
    pp "right_keys: #{@right_keys}"
    @keys.each do |key|
      ret += 1 if @right_keys.include?(key)
    end

    puts "Solution: #{ret}"
    # 1
  end
end

Solution1.new(File.open(sample_file)).solve
# Solution1.new(File.open(puzzle_file)).area(:puzzle).solve

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
# Solution2.new(File.open(puzzle_file)).area(:puzzle).threshold(20).solve
