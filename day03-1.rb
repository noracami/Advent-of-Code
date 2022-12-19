File.open('day03-input.txt', 'r') { |f|
  res = f.each.next
  len = res.size / 2
  priority = -> (char) { char.ord >= 'a'.ord ? char.ord - 'a'.ord + 1 : char.ord - 'A'.ord + 1}
  p [res[0, len], res[len, len]].map(&:chars).inject { |a,b| a - (a - b) }.map(&priority)
}
