sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

class Array
  def insert_add_or_multiply
    masks = (0...(2**(size - 1))).map { _1.to_s(2).rjust(size - 1, '0') }

    ret = {}
    # pp masks
    masks.each do |mask|
      iterate_mask = mask.each_char
      ans = first
      # pp self
      mask.each_char.with_index do |m, i|
        case m
        when '0'
          ans += self[i + 1]
        when '1'
          ans *= self[i + 1]
        end
      end
      iterate_mask.rewind
      ret[ans] = map.with_index { |v, i| "#{v} #{mask[i] == '0' ? '+' : '*'}" }.join(' ')[0..-3]
    end

    # puts "Masks: #{masks}"
    ret
  end

  def insert_add_or_multiply_or_combine
    masks = (0...(3**(size - 1))).map { _1.to_s(3).rjust(size - 1, '0') }

    ret = {}
    # pp masks
    masks.each do |mask|
      iterate_mask = mask.each_char
      ans = first
      # pp self
      mask.each_char.with_index do |m, i|
        case m
        when '0'
          ans += self[i + 1]
        when '1'
          ans *= self[i + 1]
        when '2'
          ans = (ans.to_s + self[i + 1].to_s).to_i
        end
      end
      iterate_mask.rewind
      ret[ans] = map.with_index do |v, i|
        "#{v} #{if mask[i] == '0'
                  '+'
                else
                  mask[i] == '1' ? '*' : '|'
                end}"
      end.join(' ')[0..-3]
    end

    ret
  end
end

class Solution1
  def initialize(input)
    case input
    when File
      @data = input.readlines.map(&:strip)
    end
  end

  def solve
    ret = 0

    @data.each do |line|
      target, candidates = line.split(':')
      target = target.to_i
      candidates_array = candidates.split.map(&:to_i)
      res = candidates_array.insert_add_or_multiply
      next unless res.keys.include?(target)

      puts "Found: #{target} = #{res[target]}"

      # to re-validate the equation
      va = res[target].split
      start_val = va.shift.to_i
      va.each_slice(2) do |op, v|
        case op
        when '+'
          start_val += v.to_i
        when '*'
          start_val *= v.to_i
        when '|'
          start_val = (start_val.to_s + v).to_i
        end
      end
      puts(start_val == target)

      ret += target
    end

    puts "Result: #{ret}"
  end
end

Solution1.new(File.open(sample_file)).solve
# Solution1.new(File.open(puzzle_file)).solve

class Solution2 < Solution1
  def solve
    ret = 0

    @data.each do |line|
      target, candidates = line.split(':')
      target = target.to_i
      candidates_array = candidates.split.map(&:to_i)
      res = candidates_array.insert_add_or_multiply_or_combine
      next unless res.keys.include?(target)

      puts "Found: #{target} = #{res[target]}"

      # to re-validate the equation
      va = res[target].split
      start_val = va.shift.to_i
      va.each_slice(2) do |op, v|
        case op
        when '+'
          start_val += v.to_i
        when '*'
          start_val *= v.to_i
        when '|'
          start_val = (start_val.to_s + v).to_i
        end
      end
      puts(start_val == target)

      ret += target
    end

    puts "Result: #{ret}"
  end
end

Solution2.new(File.open(sample_file)).solve
# Solution2.new(File.open(puzzle_file)).solve
