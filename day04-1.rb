File.open('day04-input.txt', 'r') { |f|
  res = f.map { |line|
    first, second = line.chomp.split(',').map {|_| _.split('-').map(&:to_i) }
    (first[0] >= second[0] && first[1] <= second[1]) || (first[0] <= second[0] && first[1] >= second[1])
  }
  
  p res.count true
}

File.open('day04-input.txt', 'r') { |f|
  res = f.map { |line|
    first, second = line.chomp.split(',').map {|_| _.split('-').map(&:to_i) }
    first[0] > second[1] || first[1] < second[0]
  }
  
  p res.count false
}
