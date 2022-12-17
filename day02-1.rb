def duel(opponent, yourself)
  res = [opponent, yourself]

  if [['A', 'Y'], ['B', 'Z'], ['C', 'X']].include? res
    'win'
  elsif [['A', 'X'], ['B', 'Y'], ['C', 'Z']].include? res
    'draw'
  else
    'lose'
  end
end

def score(opponent, yourself)
  shape = {'X': 1, 'Y': 2, 'Z': 3}
  outcome = {'win': 6, 'draw': 3, 'lose': 0}

  shape[yourself.to_sym] + outcome[duel(opponent, yourself).to_sym]
end

File.open('day02-1-input.txt', 'r') { |f|
  res = f.reduce(0) { |sum, line|
    sum + score(line[0], line[2])
  }
  p res
}
