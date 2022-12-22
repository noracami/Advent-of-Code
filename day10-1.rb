SignalStrengths = *(0...6).map { |x| 20 + x * 40 }

File.open('day10-input.txt', 'r') { |f|
  res = f.map { |line|
    /addx (?<value>.+)\n/ =~ line
    value.nil? ? :noop : value.to_i
  }

  register = 1
  cycles = 220
  execution = {consumer: 0}
  cmd = res.each
  sum_of_six_signal_strengths = 0

  1.upto(cycles) { |i|
    # start cycle
    if execution[:consumer].zero?
      _ = cmd.next

      execution =
        _ == :noop ?
        {consumer: 1} :
        {consumer: 2, value: _}
    end
    
    # during the 20th, 60th, 100th, 140th, 180th, and 220th cycles
    sum_of_six_signal_strengths += register * i if SignalStrengths.include? i

    # after cycle
    execution[:consumer] -= 1 if execution[:consumer] >= 1
    register += execution[:value] if execution[:value] && execution[:consumer].zero?
  }
  p sum_of_six_signal_strengths
}
