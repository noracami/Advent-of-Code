# for each tree in map
# observe from up down left and right
# mark if it can be seen
# count that can't be see

File.open('day08-input.txt', 'r') { |f|
  trees = f.map { |line| line.chomp.chars.map { |tree| {height: tree.to_i, visible: false}}}
  trees2 = trees.map { |_| _.map { |tree| {height: tree[:height], view: []}}}

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

  mark_trees2 = -> line {
    candidates = [line.first[:height]]
    line.drop(1).map { |tree|
      height = tree[:height]
      view = tree[:view]
      
      viewing_distance = candidates.reverse.index { |e| e >= height }
      viewing_distance = viewing_distance.nil? ? candidates.size : viewing_distance + 1

      view << viewing_distance
      candidates << height
      
      {height:, view:}
    }.unshift line.first
  }

  trees = trees.map(&mark_trees)
  # p trees.sum { |line| line.select {|tree| tree[:visible]}.size}
  
  trees2 = trees2.map(&mark_trees2)
  # p trees2.map { |line| line.map {|tree| tree[:view].inject(:*) unless tree[:view].empty?}.compact.max}.max
  
  trees = trees.transpose
  trees2 = trees2.transpose

  trees = trees.map(&mark_trees)
  # p trees.sum { |line| line.select {|tree| tree[:visible]}.size}

  trees2 = trees2.map(&mark_trees2)
  # p trees2.map { |line| line.map {|tree| tree[:view].inject(:*) unless tree[:view].empty?}.compact.max}.max
  
  trees.map!(&:reverse)
  trees2.map!(&:reverse)

  trees = trees.map(&mark_trees)
  # p trees.sum { |line| line.select {|tree| tree[:visible]}.size}

  trees2 = trees2.map(&mark_trees2)
  # p trees2.map { |line| line.map {|tree| tree[:view].inject(:*) unless tree[:view].empty?}.compact.max}.max

  trees = trees.transpose.map(&:reverse)
  trees2 = trees2.transpose.map(&:reverse)

  trees = trees.map(&mark_trees)
  p trees.sum { |line| line.select {|tree| tree[:visible]}.size}

  trees2 = trees2.map(&mark_trees2)
  p trees2.map { |line| line.map {|tree| tree[:view].inject(:*) unless tree[:view].empty?}.compact.max}.max
}
