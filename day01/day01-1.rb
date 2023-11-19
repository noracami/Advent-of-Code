File.open('day01-1-input.txt', 'r') { |f|
  res = f.to_a.chunk { |line| line == "\n" ? :_separator : true }
  res = res.map {|a,b| b.map {|calories| calories.to_i}.sum}.max(3)
  p res.first
  p res.sum
  # f.each { |line| p line }
}
