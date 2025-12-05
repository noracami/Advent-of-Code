sample_file = './sample.txt'
puzzle_file = './input.txt'

def merge_ranges(ranges)
  # 1. 一樣要先排序，這是合併的大前提
  sorted = ranges.sort_by(&:begin)

  # 2. 改用 each_with_object，省去處理回傳值的麻煩
  sorted.each_with_object([]) do |current, result|
    prev = result.last

    # 核心修改在這裡：
    # 直接問 "前一個範圍" 是否跟 "當前範圍" 重疊？
    # 使用 &. (safe navigation) 處理 result 一開始為空的情況
    if prev&.overlap?(current)
      # 有重疊 -> 合併
      # 即使重疊，結束點也要取兩者中比較遠的那個 (例如 1..10 和 2..5，要保留 10)
      new_end = [prev.end, current.end].max
      result[-1] = prev.begin..new_end
    else
      # 沒重疊 (或是第一個元素) -> 直接加入
      result << current
    end
  end
end

def solution_one(filename)
  # take every ingredient id to check range
  puts 'run part 1'
  puts filename
  data = File.readlines(filename, chomp: true)

  fresh_id_ranges, ingredient_ids = data.chunk { |a| a.empty? }.reject { |arr| arr[0] }.map(&:last)

  ret = 0
  # create ranges
  check_rangers = fresh_id_ranges.map do |range|
    Range.new *range.split('-').map(&:to_i)
  end

  # take every ingredient id
  ingredient_ids.map(&:to_i).each do |ingredient_id|
    if check_rangers.any? { |range| range.cover? ingredient_id }
      ret += 1
    end
  end

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  # concat every range and count
  puts 'run part 2'
  puts filename
  data = File.readlines(filename, chomp: true)

  fresh_id_ranges, _ingredient_ids = data.chunk { |a| a.empty? }.reject { |arr| arr[0] }.map(&:last)

  # create ranges
  check_rangers = fresh_id_ranges.map do |range|
    Range.new *range.split('-').map(&:to_i)
  end

  # merge ranges
  check_rangers = merge_ranges(check_rangers)

  ret = check_rangers.map(&:count).sum

  puts "answer: #{ret}"
end

solution_two(sample_file)
solution_two(puzzle_file)
