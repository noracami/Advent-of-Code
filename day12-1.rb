# part1 -> start from S, read specific node "E"
# part2 -> start from E, read node "a" with minimum steps

class LinkedList
  attr_accessor :neighbor, :reach, :previous, :steps_to_start
  attr_reader :name, :height
  
  @@S = nil
  @@E = nil

  def self.start_position
    @@S
  end

  def self.best_signal_location
    @@E
  end

  def initialize(height:, x:, y:)
    @name = "#{x}-#{y}"
    @neighbor = []
    @reach = []
    @previous = nil
    @steps_to_start = nil

    case height
    when 'S'
      set_start_position
    when 'E'
      set_best_signal_location
    else
      @height = height.ord - 'a'.ord
    end
  end

  def set_start_position
    @height = 0
    @steps_to_start = 0
    @@S = self
  end

  def set_best_signal_location
    @height = 25
    @steps_to_start ||= nil
    @@E = self
  end

  def reset_steps
    @steps_to_start = nil
  end

  def reverse_height
    @height = 25 - @height
  end

  def calculate_steps
    if @steps_to_start.nil?
      @previous = @reach.reject{|node| node.steps_to_start.nil? }.min_by{|node| node.steps_to_start.to_i}
      @steps_to_start = @previous.steps_to_start + 1
    end
  end

  def calculate_steps_2
    # puts 'self.calculate_steps'
    # puts self
    # puts 'self done==========='
    if @steps_to_start.nil?
      # puts @reach
      @previous = @neighbor.reject{|node| node.steps_to_start.nil? }.min_by{|node| node.steps_to_start.to_i}
      # print 'self ->> '
      # puts self
      # puts "=== neighbor ===\n\n"
      # puts @neighbor#.map{|n| [n.name, n.height].join('--') }
      # puts "\n=== neighbor ===\n"
      # print 'previous ->> '
      # puts @previous
      # sleep 10
      @steps_to_start = @previous.steps_to_start + 1
    end
    # puts self
  end

  def establish_link(node)
    return if @neighbor.include?(node)

    raise :node_must_be_a_LinkedList if node.class != LinkedList
    
    if node.height - self.height >= -1
      node.neighbor << self
      self.reach << node
    end

    if self.height - node.height >= -1
      self.neighbor << node
      node.reach << self
    end

    node.reach.uniq!
    self.reach.uniq!
  end

  def to_s
    [
      "position: #{@name}",
      "height: #{@height}",
      # "neighbor: #{@neighbor.map(&:name)}",
      # "reach: #{@reach.map(&:name)}",
      "previous: #{@previous&.name}",
      "steps_to_start: #{@steps_to_start}"
    ].join("\t")
  end
end

INPUT = "day12-input.txt"
SAMPLE = "day12-sample.txt"

File.open(INPUT, 'r') { |f|
  res = f.map.with_index { |line, x|
    line.chomp.chars.map.with_index { |grid, y|
      LinkedList.new(height: grid, x:, y:)
    }
  }

  res.each_with_index { |line, x|
    line.each_with_index { |node, y|
      node.establish_link res[x-1][y] if x > 0
      node.establish_link res[x][y-1] if y > 0
    }
  }

  # part 1
  part_1 = true || nil
  if part_1
    current_nodes = [LinkedList.start_position]
    while !current_nodes.empty?
      next_nodes = []
      current_nodes.each { |current_node|
        next_nodes.concat(current_node.neighbor.reject(&:steps_to_start))
        current_node.calculate_steps
      }
      next_nodes.uniq!
      current_nodes = next_nodes
    end
    puts
    puts '=== part 1 ==='
    puts
    print 'start_position -->> '
    puts LinkedList.start_position
    print 'best_signal_location -->> '
    puts LinkedList.best_signal_location
    puts
    puts '=== part 1 ==='
    puts
  end
    
  # part 2
  part_2 = true || nil
  if part_2
    res.each { |line|
      line.each { |node|
        node.reset_steps
        node.reverse_height
      }
    }
    LinkedList.best_signal_location.set_start_position
    
    current_nodes = [LinkedList.start_position]
    while !current_nodes.empty?
      next_nodes = []
      current_nodes.each { |current_node|
        next_nodes.concat(current_node.reach.reject(&:steps_to_start))
        current_node.calculate_steps_2
      }
      next_nodes.uniq!
      current_nodes = next_nodes
    end
    res.flat_map { |_|
      _.select { |node|
        node.height == 25
      }.reject { |node|
        node.steps_to_start.nil?
      }
    }
    .min_by { |node| node.steps_to_start }
    .set_best_signal_location
    puts
    puts '=== part 2 ==='
    puts
    print 'start_position -->> '
    puts LinkedList.start_position
    print 'best_signal_location -->> '
    puts LinkedList.best_signal_location
    puts
    puts '=== part 2 ==='
    puts
  end
}
