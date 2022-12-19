File.open('day03-input.txt', 'r') { |f|
  def priority (char)
    if char.ord >= 'a'.ord
      char.ord - 'a'.ord + 1
    elsif char.ord <= 'Z'.ord
      char.ord - 'A'.ord + 1 + 26
    end
  end

  def intersection (a, b)
    b.reduce("") { |memo, char|
      if a.include? char
        memo + char
      else
        memo
      end
    }.chars.uniq
  end
  
  res = f.each_slice(3).reduce(0) { |sum, rucksack|
    a, b, c = rucksack.map(&:chomp).map(&:chars)
    sum += priority intersection(*[intersection(*[a, b]), c]).last
  }
  
  p res
}
