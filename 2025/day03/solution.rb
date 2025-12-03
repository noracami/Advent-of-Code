sample_file = './sample.txt'
puzzle_file = './input.txt'

# dp = [0]...[0] size = batteries
# how to find dp[0]'s value?
# n from 9 to 0, choose n if str.index(n) <= str.size - batteries + index else n -= 1
def dp(str, batteries, boundary=1000)
  res = []
  0.upto(batteries - 1).each do |i|
    # puts "#{i}: #{str}"
    9.downto(0) do |n|
      index_n = str.index(n.to_s)
      if index_n && index_n <= str.size - batteries + i
        res << n
        str = str[index_n + 1, boundary]
        break
      end
    end
  end

  res.join.to_i
end

def solution_one(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  ret = data.sum { |line| dp(line, 2) }

  puts "answer: #{ret}"
end

solution_one(sample_file) # == 357
solution_one(puzzle_file) # == 17405

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)

  ret = data.sum { |line| dp(line, 12) }

  puts "answer: #{ret}"
end

solution_two(sample_file) # == 3121910778619
solution_two(puzzle_file) # == 171990312704598
