def is_touch?(x, y)
  _ =[[-1, 1], [0, 1], [1, 1],
      [-1, 0], [0, 0], [1, 0],
      [-1,-1], [0,-1], [1,-1]]
  _.include? [x, y]
end

File.open('day09-input.txt', 'r') { |f|
  res = f.map { |line|
    /(?<direction>[DLRU]) (?<steps>\d+)/ =~ line
    [direction, steps.to_i]
  }

  # knot: {x: 0, y: 0}
  rope = Array.new(2).map {{x: 0, y: 0}}
  visits = {}

  res.each { |dir, steps|
    # move HEAD
    steps.times {
      case dir
      when "R"
        rope[0][:x] += 1
      when "L"
        rope[0][:x] -= 1
      when "U"
        rope[0][:y] += 1
      when "D"
        rope[0][:y] -= 1
      else
        raise :error
      end

      # check next knot
      rope.each_cons(2) { |head, tail|
        distance = [head[:x] - tail[:x], head[:y] - tail[:y]]
        if !(is_touch? *distance)
          x, y = distance
          tail[:x] += 1 if x > 0
          tail[:x] -= 1 if x < 0
          tail[:y] += 1 if y > 0
          tail[:y] -= 1 if y < 0
        end
      }
  
      visits["#{rope[-1][:x]}-#{rope[-1][:y]}"] = true
    }
  }

  puts visits.size

  # part2
  rope = Array.new(10).map {{x: 0, y: 0}}
  visits = {}
  res.each { |dir, steps|
    # move HEAD
    steps.times {
      case dir
      when "R"
        rope[0][:x] += 1
      when "L"
        rope[0][:x] -= 1
      when "U"
        rope[0][:y] += 1
      when "D"
        rope[0][:y] -= 1
      else
        raise :error
      end

      # check next knot
      rope.each_cons(2) { |head, tail|
        distance = [head[:x] - tail[:x], head[:y] - tail[:y]]
        if !(is_touch? *distance)
          x, y = distance
          tail[:x] += 1 if x > 0
          tail[:x] -= 1 if x < 0
          tail[:y] += 1 if y > 0
          tail[:y] -= 1 if y < 0
        end
      }
  
      visits["#{rope[-1][:x]}-#{rope[-1][:y]}"] = true
    }
  }

  puts visits.size
}
