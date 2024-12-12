require 'benchmark'

sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

class Solution1
  def initialize(input)
    case input
    when File
      @data = input.readlines.map(&:strip).first
    end
  end

  def solve
    blocks = []
    free_space = []
    id_seq = 0
    idx = 0
    @data.chars.each_slice(2) do |block, space|
      blocks << [id_seq, block.to_i, idx]
      idx += block.to_i
      free_space << [space.to_i, idx] if space
      idx += space.to_i
      id_seq += 1
    end

    point_to_block = true
    pointer = 0
    memory = 0
    debug_memory = []
    expand_blocks = []
    while blocks.any? || expand_blocks.any?
      if point_to_block
        if blocks.any?
          id_seq, block, idx = blocks.shift
          block.times do
            memory += id_seq * pointer
            pointer += 1
          end
          debug_memory << block.times.map { id_seq }
          point_to_block = false

          next
        end

        expand_blocks.each do |expand_block|
          memory += expand_block * pointer
          pointer += 1
          debug_memory << [expand_block]
        end

        break
      elsif free_space.any?
        space, idx = free_space.shift
        while blocks.any? && expand_blocks.size < space
          id_seq, block, idx = blocks.pop
          block.times { expand_blocks << id_seq }
        end

        space.times do
          expand_block = expand_blocks.shift
          if expand_block
            memory += expand_block * pointer
            pointer += 1
          end
          debug_memory << [expand_block] if expand_block
        end
        if blocks.empty?
          expand_blocks.each do |expand_block|
            memory += expand_block * pointer
            pointer += 1
            debug_memory << [expand_block]
          end
          break
        end

        point_to_block = true
      else
        blocks.each do |id_seq, i_block, _idx|
          i_block.times do
            memory += id_seq * pointer
            pointer += 1
          end
          debug_memory << i_block.times.map { id_seq }
        end
        expand_blocks.reverse.each do |i_block|
          memory += i_block * pointer
          pointer += 1
        end
        break
      end
    end

    ret = memory

    # puts "data.size: #{@data.size}"
    # puts debug_memory.join
    # check = '0099811188827773336446555566'
    # puts check

    # check.chars.map.with_index { |char, index| char.to_i * index }.sum.then { |it| puts "Check: #{it}" }

    puts "Result: #{ret}"
  end
end

Solution1.new(File.open(sample_file)).solve
Solution1.new(File.open(puzzle_file)).solve

class Solution2 < Solution1
  def solve(no_result: true)
    blocks = []
    free_space = []
    id_seq = 0
    pointer = 0
    @data.chars.each_slice(2) do |block, space|
      blocks << [id_seq, pointer, pointer + block.to_i - 1]
      id_seq += 1
      pointer += block.to_i

      if space.to_i.positive?
        free_space << [pointer, pointer + space.to_i - 1]
        pointer += space.to_i
      end
    end

    # construct the memory
    memory = Array.new(pointer, :empty)
    blocks.each do |block_id_seq, start, stop|
      (start..stop).each { |idx| memory[idx] = block_id_seq }
    end

    @counter = 0
    @max_counter = -1
    blocks.reverse.each do |block_id_seq, start, stop|
      @counter += 1 if @counter < @max_counter
      pp "block_id_seq: #{block_id_seq}, start: #{start}, stop: #{stop}" if @counter < @max_counter
      pp "free_space: #{free_space}" if @counter < @max_counter

      space_candidate = nil
      free_space.each_with_index do |(start_space, stop_space), idx|
        if start < start_space
          # puts 'not enough space to insert'
          break
        end

        pp "start_space: #{start_space}, stop_space: #{stop_space}" if @counter < @max_counter
        # found the free space to insert
        next unless stop - start <= stop_space - start_space

        if @counter < @max_counter
          puts 'found the free space to insert'
          pp "block size: #{stop - start}, space size: #{stop_space - start_space}"
        end
        space_candidate = idx
        break
      end

      pp "space_candidate: #{space_candidate}" if @counter < @max_counter
      next unless space_candidate

      # remove the block from the original position
      (start..stop).each { |idx| memory[idx] = :empty }

      # move the block to the free space
      space_start = free_space[space_candidate][0]
      space_stop = stop - start + space_start
      (space_start..space_stop).each { |idx| memory[idx] = block_id_seq }
      free_space[space_candidate] = [space_stop + 1, free_space[space_candidate][1]]

      puts "new free_space: #{free_space[space_candidate]}\n\n" if @counter < @max_counter

      free_space.delete_at(space_candidate) if free_space[space_candidate][0] > free_space[space_candidate][1]
    end

    # memory = blocks.zip(free_space).join
    # pp memory.map { |it| it == :empty ? '.' : it }.join
    ret = 0
    memory.each_with_index do |block_id_seq, idx|
      next if block_id_seq == :empty

      ret += block_id_seq * idx
    end

    puts "Result: #{ret}" unless no_result

    # check = '00992111777.44.333....5555.6666.....8888..'
    # pp check
    # super(consider_resonant_harmonics: true)
  end
end

Solution2.new(File.open(sample_file)).solve
Solution2.new(File.open(puzzle_file)).solve

n = 1
Benchmark.bm do |benchmark|
  benchmark.report("Solution2") do
    n.times do
      Solution2.new(File.open(puzzle_file)).solve(no_result: true)
    end
  end
end
