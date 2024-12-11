sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

class Solution1
  def initialize(input)
    case input
    when File
      @data = input.readlines.map(&:strip).first
    when String
      @data = input
    end

    @answer ||= Hash.new { |h, k| h[k] = 0 }
    @data.split.each { |c| @answer[c] = 1 }
  end

  def set_blink_times(times)
    puts "Blink times: #{times}"
    @blink_times = times
    self
  end

  def print_input
    puts "Input: #{@data}"
  end

  def print_answer
    puts "Result: #{@answer.values.sum}\n\n"
  end

  def blink
    source = @answer.to_a
    source.each do |stone, quantity|
      @answer[stone] -= quantity
      @answer.delete(stone) if @answer[stone].zero?
      if stone == '0'
        new_stone = '1'
        @answer[new_stone] += quantity
      elsif stone.size.even?
        left, right = stone.chars.each_slice(stone.size / 2).map(&:join).map(&:to_i).map(&:to_s)
        @answer[left] += quantity
        @answer[right] += quantity
      else
        new_stone = (stone.to_i * 2024).to_s
        @answer[new_stone] += quantity
      end
    end
  end

  def solve
    print_input

    raise 'Blink times not set' unless @blink_times

    @blink_times.times { blink }

    print_answer
  end
end

Solution1.new(File.open(sample_file)).set_blink_times(6).solve
Solution1.new(File.open(sample_file)).set_blink_times(25).solve
Solution1.new(File.open(puzzle_file)).set_blink_times(25).solve
Solution1.new(File.open(puzzle_file)).set_blink_times(75).solve

# class Solution2 < Solution1
#   def solve
#     set_blink_times(75)
#     super
#   end
# end

# # Solution2.new(File.open(sample_file)).solve
# Solution2.new(File.open(puzzle_file)).solve
# # Solution2.new('0').solve
