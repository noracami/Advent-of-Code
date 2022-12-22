def move_head
end

def measure_boundary arr
  x = 0
  y = 0
  bounds = {left: 0, right: 0, up: 0, down: 0}

  arr.each { |dir, steps|
    case dir
    when "R"
      x += steps
      bounds[:left] = x if x > bounds[:left]
    when "L"
      x -= steps
      bounds[:right] = x if x < bounds[:right]
    when "U"
      y += steps
      bounds[:up] = y if y > bounds[:up]
    when "D"
      y -= steps
      bounds[:down] = y if y < bounds[:down]
    else
      raise :error
    end
  }

  bounds
end

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

  bounds = measure_boundary res
  
  head = {x: 0, y: 0}
  tail = {x: 0, y: 0}
  visits = {}

  res.each { |dir, steps|
    # move HEAD
    steps.times {
    case dir
    when "R"
      head[:x] += 1
    when "L"
      head[:x] -= 1
    when "U"
      head[:y] += 1
    when "D"
      head[:y] -= 1
    else
      raise :error
    end

    distance = [head[:x] - tail[:x], head[:y] - tail[:y]]

    if !(is_touch? *distance)
      x, y = distance
      tail[:x] += 1 if x > 0
      tail[:x] -= 1 if x < 0
      tail[:y] += 1 if y > 0
      tail[:y] -= 1 if y < 0

      visits["#{tail[:x]}-#{tail[:y]}"] = true
    end
    }
  }

  puts head
  puts tail
  puts visits.size
}
