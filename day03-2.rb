File.open('day03-input.txt', 'r') { |f|
  priority = -> (char) {
    if char.ord >= 'a'.ord
      char.ord - 'a'.ord + 1
    elsif char.ord <= 'Z'.ord
      char.ord - 'A'.ord + 1 + 26
    end
  }
  
  # p f.each_slice(3).first 2
  
  res = f.each_slice(3).first(2).reduce(0) { |sum, rucksack|
    p sum
    p rucksack
    # sum += [rucksack[0, len], rucksack[len, len]].map(&:chars).inject { |a, b| a - (a - b) }.map(&priority).last
  }

}
