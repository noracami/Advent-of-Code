# for each tree in map
# observe from up down left and right
# mark if it can be seen
# count that can't be see

File.open('day08-input.txt', 'r') { |f|
  trees = f.map { |line| line.chomp.chars.map { |tree| {height: tree.to_i, visible: false}}}

  mark_trees = -> line {
    tallest = -1
    line.map { |tree|
      if tree[:height] > tallest
        tallest = tree[:height]
        {height: tree[:height], visible: true}
      else
        tree
      end
    }
  }

  trees = trees.map(&mark_trees)

  p trees.sum { |line| line.select {|tree| tree[:visible]}.size}

  trees = trees.transpose

  trees = trees.map(&mark_trees)

  p trees.sum { |line| line.select {|tree| tree[:visible]}.size}

  trees.map!(&:reverse)

  trees = trees.map(&mark_trees)

  p trees.sum { |line| line.select {|tree| tree[:visible]}.size}

  trees = trees.transpose.map(&:reverse)

  trees = trees.map(&mark_trees)

  p trees.sum { |line| line.select {|tree| tree[:visible]}.size}
}
