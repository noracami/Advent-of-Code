File.open('day06-input.txt', 'r') { |f|
  res = f.readline

  res.chomp!

  res.chars.each_cons(4).with_index { |k, idx|
    if k.uniq.size == 4
      p idx + 4
      break
    end
  }

  res.chars.each_cons(14).with_index { |k, idx|
    if k.uniq.size == 14
      p idx + 14
      break
    end
  }
}
