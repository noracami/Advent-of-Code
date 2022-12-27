class LinkedList
  attr_accessor :neighbor, :steps_to_start
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
    @steps_to_start = nil

    case height
    when 'S'
      @height = 0
      @steps_to_start = 0
      @@S = self
    when 'E'
      @height = 26
      @@E = self
    else
      @height = height.ord - 'a'.ord
    end
  end
  
  def calculate_steps
    if @steps_to_start.nil?
      @steps_to_start = @neighbor
        .map(&:steps_to_start)
        .compact
        .map(&:to_i).min + 1
    end
  end

  def establish_link(node)
    return if @neighbor.include?(node)

    raise :node_must_be_a_LinkedList if node.class != LinkedList
    
    if (node.height - self.height).abs <= 1
      @neighbor << node
      node.neighbor << self
    end
  end

  def to_s
    [
      "position: #{@name}",
      "height: #{@height}",
      "neighbor: #{@neighbor.map(&:name)}",
      "steps_to_start: #{@steps_to_start}"
    ].join("\t")
  end
end

# a = LinkedList.new(height: 'S', x: 0, y: 1)
# b = LinkedList.new(height: 'b', x: 1, y: 1)
# c = LinkedList.new(height: 'E', x: 2, y: 1)
# a.establish_link(b)
# a.establish_link(c)
# b.establish_link(a)

# puts a
# puts a.neighbor

# return

INPUT = "day12-input.txt"
SAMPLE = "day12-sample.txt"

File.open(INPUT, 'r') { |f|
  res = f.map.with_index { |line, x|
    line.chomp.chars.map.with_index { |grid, y|
      LinkedList.new(height: grid, x:, y:)
    }
  }
  # X_SIZE = res.size
  # Y_SIZE = res[0].size
  res.each_with_index { |line, x|
    line.each_with_index { |node, y|
      node.establish_link res[x-1][y] if x > 0
      node.establish_link res[x][y-1] if y > 0
    }
  }
  # puts res[0][0]
  # puts LinkedList.start_position
  # puts LinkedList.best_signal_location

  current_nodes = [LinkedList.start_position]
  # current_nodes = []
  
  while !current_nodes.empty?
    # puts current_nodes
    next_nodes = []
    current_nodes.each { |curr_node|
      # p 1
      # sleep 1
      next_nodes.concat(curr_node.neighbor.reject(&:steps_to_start))
      # puts next_nodes
      curr_node.calculate_steps
      # p 5
      # puts curr_node
      # sleep 0.03
    }
    current_nodes = next_nodes.uniq
    # p current_nodes[0].class
  end
  puts LinkedList.start_position
  p '---'
  puts LinkedList.best_signal_location
  p res[20].map(&:steps_to_start).join('-')
}
