File.open('day05-input.txt', 'r') { |f|
  res = f.first 9
  # puts res
  # res.map!(&:chomp)
  res.map! { |line|
    line.chomp.chars.each_slice(4).map(&:join).map(&:strip)
  }

  # puts res.transpose.map(&:join)

  res = res.transpose

  stacks = [nil] * 9
  
  stacks = stacks.map.with_index { |_, idx|
    res[idx][0, 8].reject {|_| _.empty? }
  }

  stacks.unshift nil

  # p stacks

  def stack_pop(stack_entry)
    stack_entry.shift
  end

  def stack_push(stack_entry, element)
    stack_entry.unshift element
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
  # p procedures.size

  procedures.each { |cmd|
    cmd[:moved_crates].times {
      stack_push stacks[cmd[:to]], (stack_pop stacks[cmd[:from]])
    }
  }

  puts stacks[1, 100].map(&:first).join.gsub(/[\[\]]/, "")
}
