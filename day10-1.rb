Signal_Strengths = *(0...6).map { |x| 20 + x * 40 }

File.open('day10-input.txt', 'r') { |f|
  res = f.map { |line|
    /addx (?<value>.+)\n/ =~ line
    value.nil? ? :noop : value
  }

  register = 1
  cycles = 220

  cycles.times { |i|
    if Signal_Strengths.include? i
      p i
    end
  }
}
