File.open('day05-input.txt', 'r') { |f|
  res = f.first 9
  res.map! { |line|
    line.chomp.chars.each_slice(4).map(&:join).map(&:strip)
  }
  res = res.transpose

  stacks = Array.new(9)
  
  stacks = stacks.map.with_index { |_, idx|
    res[idx][0, 8].reject {|_| _.empty? }
  }

  stacks.unshift nil

  def stack_pop(stack_entry, n=1)
    stack_entry.shift n
  end

  def stack_push(stack_entry, element)
    stack_entry.unshift(element).flatten!
  end

  f.readline

  procedures = f.map { |line|
    /move (?<moved_crates>\d+) from (?<from>\d+) to (?<to>\d+)\n/ =~ (line)
    {
      moved_crates: moved_crates.to_i,
      from: from.to_i,
      to: to.to_i
    }
  }

  stacks2 = stacks.map {|_| Array.new(_.to_a) }

  # procedures = procedures.first 4

  procedures.each { |cmd|
    cmd[:moved_crates].times {
      stack_push stacks[cmd[:to]], (stack_pop stacks[cmd[:from]])
    }

    stack_push stacks2[cmd[:to]], (stack_pop stacks2[cmd[:from]], cmd[:moved_crates])
  }

  puts stacks[1, 100].map(&:first).join.gsub(/[\[\]]/, "")

  puts stacks2[1, 100].map(&:first).join.gsub(/[\[\]]/, "")
}
