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

  def parse_input
    regexp = /(Button [AB]): X\+(.+), Y\+(.+)|(Prize): X=(.+), Y=(.+)/
    ret = @data
      .chunk { |line| line.empty? }
      .map(&:last)
      .filter { |lines| lines.size == 3 }
      .map { |machine|
        machine.map { |str|
          str.scan(regexp)
        }.flatten.compact.each_slice(3).each_with_object({}) { |(a, b, c), obj|
          obj[a] = [b.to_i, c.to_i]
        }
      }
    @machines = ret
  end

  def find_minimum(a, b, c, d, target_x, target_y)
    # 初始化最小值和最佳解
    min_value = Float::INFINITY
    best_x = nil
    best_y = nil

    # 暴力搜尋所有可能的非負整數解
    # 假設 x 和 y 的範圍在合理範圍內（根據目標推算）
    (0..100).each do |x| # 搜索範圍可根據需求調整
      (0..100).each do |y|
        # 驗證條件
        if x * a + y * c == target_x && x * b + y * d == target_y
          value = 3 * x + y
          if value < min_value
            min_value = value
            best_x = x
            best_y = y
          end
        end
      end
    end

    # 回傳結果
    return { x: best_x, y: best_y, min_value: min_value } if best_x && best_y
    nil # 無解
  end

  def expand_machines
    @machines.each do |machine|
      target_x, target_y = machine['Prize']
      machine['Prize'] = [target_x + 10000000000000, target_y + 10000000000000]
    end
    puts "Machines expanded."
  end

  # 擴展歐幾里得算法
  def extended_gcd(a, b)
    if b == 0
      return [a, 1, 0] # gcd, x, y
    else
      gcd, x1, y1 = extended_gcd(b, a % b)
      x = y1
      y = x1 - (a / b) * y1
      return [gcd, x, y]
    end
  end

  # 求解單個方程的通解
  def solve_single_equation(a, b, target)
    gcd, x0, y0 = extended_gcd(a, b)

    # 如果目標值不能被 GCD 整除，則無整數解
    return nil if target % gcd != 0

    # 縮放初始解
    scale = target / gcd
    x0 *= scale
    y0 *= scale

    # 通解增量
    t_x = b / gcd
    t_y = -a / gcd

    return [x0, y0, t_x, t_y] # 初始解和增量
  end

  # 解二維線性方程組
  def solve_two_equations(a1, b1, k1, a2, b2, k2)
    # 1. 解第一個方程的通解
    result1 = solve_single_equation(a1, b1, k1)
    return nil if result1.nil?

    puts "result 1: #{result1}"
    x0, y0, t_x, t_y = result1

    # 2. 將第一個方程的解代入第二個方程
    # 第二個方程為 a2 * (x0 + k * t_x) + b2 * (y0 + k * t_y) = k2
    # 化為關於 k 的單變量方程
    new_a = a2 * t_x + b2 * t_y
    new_b = k2 - a2 * x0 - b2 * y0

    # 解新的單變量方程 new_a * k = new_b
    gcd, k0, _ = extended_gcd(new_a, new_b)
    return nil if new_b % gcd != 0

    # 縮放 k 的解
    scale = new_b / gcd
    k0 *= scale

    # 3. 回代到第一個方程的通解，得到最終解
    final_x = x0 + k0 * t_x
    final_y = y0 + k0 * t_y

    # return [final_x, final_y]
    { x: final_x, y: final_y, min_value: 3 * final_x + final_y }
  end

  def print_input
    puts "Input: #{@data}"
  end

  def print_machines
    @machines.each do |machine|
      puts machine
    end
  end

  def solve(part2 = false)
    unless part2
      # print_input
      puts "parse the input"
      parse_input
      # print_machines
    end

    answer = 0
    @machines.each do |machine|
      a, b = machine['Button A']
      c, d = machine['Button B']
      target_x, target_y = machine['Prize']
      ret = if part2
              solve_two_equations(a, c, b, d, target_x, target_y)
            else
              find_minimum(a, b, c, d, target_x, target_y)
            end
      if ret
        puts "check result"
        check_x = ret[:x] * a + ret[:y] * c == target_x
        check_y = ret[:x] * b + ret[:y] * d == target_y
        puts "check_x: #{check_x}, check_y: #{check_y}"

        puts "x: #{ret[:x]}, y: #{ret[:y]}, Minimum Value: #{ret[:min_value]}"
        answer += ret[:min_value]
      else
        # puts "No solution found."
      end
    end

    puts "Answer: #{answer}"
    # print_board
    # count_the_region
    # print_regions
  end
end

# Solution1.new(File.open(sample_file)).solve
# puts "expected: 480"

# Solution1.new(File.open(puzzle_file)).solve

class Solution2 < Solution1
  def solve
    puts "parse the input"
    parse_input
    expand_machines
    print_machines
    super(true)
  end
end

# Solution2.new(File.open(sample_file)).solve
# Solution2.new(File.open(puzzle_file)).solve
# # Solution2.new('0').solve


# {"Button A"=>[94, 34], "Button B"=>[22, 67], "Prize"=>[10000000008400, 10000000005400]}
class Solution3 < Solution1
  # 94x + 22y = 10000000008400
  # 34x + 67y = 10000000005400
  # Find one possible x, y, where x >= 0, y >= 0

  def initialize(input)
  #   @a1 = params[:ax] || 94
  #   @b1 = params[:bx] || 22
  #   @k1 = params[:px] || 10000000008400
  #   @a2 = params[:ay] || 34
  #   @b2 = params[:by] || 67
  #   @k2 = params[:py] || 10000000005400
    @factor = 10000000000000
    super(input)
  end

  def solve
    parse_input
    answer = 0
    # print_machines
    @machines.each do |machine|
      a, b = machine['Button A']
      c, d = machine['Button B']
      target_x, target_y = machine['Prize']

      # puts "a: #{a}, b: #{b}, c: #{c}, d: #{d}, target_x: #{target_x}, target_y: #{target_y}"

      ret = solve_two_equations(a, c, target_x, b, d, target_y)
      if ret && ret[:x].positive? && ret[:y].positive?
        # puts "result: #{ret}"
        answer += ret[:min_value]
      else
        # puts "No solution found."
      end
    end

    puts "Answer: #{answer}"
  end

  def det
    @a1 * @b2 - @a2 * @b1
  end

  def parse_input
    regexp = /(Button [AB]): X\+(.+), Y\+(.+)|(Prize): X=(.+), Y=(.+)/
    ret = @data
      .chunk { |line| line.empty? }
      .map(&:last)
      .filter { |lines| lines.size == 3 }
      .map { |machine|
        machine.map { |str|
          str.scan(regexp)
        }.flatten.compact.each_slice(3).each_with_object({}) { |(a, b, c), obj|

          obj[a] = [b.to_i, c.to_i]
          obj[a] = [b.to_i + @factor, c.to_i + @factor] if a == 'Prize'
        }
      }
    @machines = ret
  end

  # use the extended Euclidean algorithm to solve the equation
  def extended_gcd(a, b)
    if b == 0
      return [a, 1, 0] # gcd, x, y
    else
      gcd, x1, y1 = extended_gcd(b, a % b)
      x = y1
      y = x1 - (a / b) * y1
      return [gcd, x, y]
    end
  end

  # solve the single equation
  def solve_single_equation(a, b, target)
    gcd, x0, y0 = extended_gcd(a, b)

    return nil if target % gcd != 0

    scale = target / gcd
    x0 *= scale
    y0 *= scale

    t_x = b / gcd
    t_y = -a / gcd

    return [x0, y0, t_x, t_y]
  end

  # solve the two equations
  def solve_two_equations(a1, b1, k1, a2, b2, k2)
    result1 = solve_single_equation(a1, b1, k1)
    return nil if result1.nil?

    x0, y0, t_x, t_y = result1

    new_a = a2 * t_x + b2 * t_y
    new_b = k2 - a2 * x0 - b2 * y0

    gcd, k0, _ = extended_gcd(new_a, new_b)
    return nil if new_b % gcd != 0

    scale = new_b / gcd
    k0 *= scale

    final_x = x0 + k0 * t_x
    final_y = y0 + k0 * t_y

    { x: final_x, y: final_y, min_value: 3 * final_x + final_y }
  end
end

puts "\n\nSolution 3\n"
# # Solution3.new.solve
# # {"Button A"=>[94, 34], "Button B"=>[22, 67], "Prize"=>[10000000008400, 10000000005400]}
# Solution3.new(ax: 94, ay: 34, bx: 22, by: 67, px: 10000000008400, py: 10000000005400).solve
# # {"Button A"=>[26, 66], "Button B"=>[67, 21], "Prize"=>[10000000012748, 10000000012176]}
# Solution3.new(ax: 26, ay: 66, bx: 67, by: 21, px: 10000000012748, py: 10000000012176).solve
# # {"Button A"=>[17, 86], "Button B"=>[84, 37], "Prize"=>[10000000007870, 10000000006450]}
# Solution3.new(ax: 17, ay: 86, bx: 84, by: 37, px: 10000000007870, py: 10000000006450).solve
# # {"Button A"=>[69, 23], "Button B"=>[27, 71], "Prize"=>[10000000018641, 10000000010279]}
# Solution3.new(ax: 69, ay: 23, bx: 27, by: 71, px: 10000000018641, py: 10000000010279).solve

# # d = puzzle_file.
Solution3.new(File.open(sample_file)).solve
Solution3.new(File.open(puzzle_file)).solve
