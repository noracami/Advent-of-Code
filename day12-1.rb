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
      @height = 0
      @steps_to_start = 0
      @@S = self
    when 'E'
      @height = 25
      @@E = self
    else
      @height = height.ord - 'a'.ord
    end
  end
  
  def calculate_steps
    # if self.name == "18-4"
    #   puts self
    #   puts ".\n" * 5
    #   sleep 100
    # end
    if @steps_to_start.nil?
      # puts @reach
      @previous = @reach.reject{|node| node.steps_to_start.nil? }.min_by{|node| node.steps_to_start.to_i}
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

  current_nodes = [LinkedList.start_position]
  
  while !current_nodes.empty?
    # puts current_nodes
    next_nodes = []
    current_nodes.each { |current_node|
      next_nodes.concat(current_node.neighbor.reject(&:steps_to_start))
      current_node.calculate_steps
    }
    next_nodes.uniq!
    current_nodes = next_nodes
  end

  puts LinkedList.start_position
  p '---'
  puts LinkedList.best_signal_location
  p '---'
  # current_nodes = LinkedList.best_signal_location
  # while current_nodes.previous
  #   current_nodes = current_nodes.previous
  #   puts current_nodes
  # end
}
