sample_file = './sample.txt'
puzzle_file = './input.txt'

def solution_one(filename)
  puts filename
  data = File.readlines(filename, chomp: true)
  # puts data

  ranges = data[0].split(',').map { |range| range.split('-').map(&:to_i) }

  ret = 0
  ranges.each do |left, right|
    # pp _ = { left:, right: }
    mod = 10 ** (left.to_s.size / 2.0).ceil + 1
    flag = 10 ** ((mod.to_s.size - 1) * 2) - 1
    # pp _ = { mod:, flag: }
    (left..right).each do |n|
      next if n.to_s.size.odd?

      if n % mod == 0
        # pp "n: #{n}"
        ret += n
      end

      if n == flag
        mod = (mod - 1) * 10 + 1
        flag = 10 ** ((mod.to_s.size - 1) * 2) - 1
      end
    end
  end

  puts ret
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)
  # puts data

  ret = 0
  ranges = data[0].split(',').map { |range| range.split('-') }
  ranges.each do |a, b|
    n_cache = {}
    (a..b).each do |n|
      1.upto(n.size / 2).each do |m|
        next if n_cache[n]

        if n.size % m == 0
          # pp _ = { n:, m: }
          if n.each_char.each_slice(m).map(&:join).uniq.size == 1
            n_cache[n] = true
            ret += n.to_i
            # pp _ = { m:, n:, t: n.each_char.each_slice(m).map(&:join) }
          end
        end
      end
    end
  end

  puts ret
end

solution_two(sample_file)
solution_two(puzzle_file) # about 25 seconds
