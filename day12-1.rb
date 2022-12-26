class LinkedList


end

INPUT = "day12-input.txt"
SAMPLE = "day12-sample.txt"

File.open(SAMPLE, 'r') { |f|
  res = f.flat_map.with_index { |line, x|
    line.chomp.chars.map.with_index { |grid, y|
      [x, y, grid]
    }
  }
  # p res

  # MAP = res.sort_by {|x, y, grid| grid }.chunk_while { |i, j| i[2] == j[2] }.to_a
  # MAP = res.group_by { |x, y, grid| grid }
  # p MAP

  # traveled = [] << MAP["E"]

  # ("a".."z").reverse_each { |height|
    # p MAP[height]
  # }

  # p traveled
  # p MAP["z"]
}
