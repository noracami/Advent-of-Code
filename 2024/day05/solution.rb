sample_file = File.join(File.dirname(__FILE__), 'sample.txt')
puzzle_file = File.join(File.dirname(__FILE__), 'input.txt')

def solution_one(filename, input = nil)
  puts 'using input' if input
  puts filename
  data = input || File.readlines(filename, chomp: true)
  first_section, second_section = data.slice_when { _1.empty? }.to_a
  first_section.reject!(&:empty?)
  first_section = first_section.each_with_object({}) do |line, hash|
    key, value = line.split('|')
    if hash[key]
      hash[key] << value
    else
      hash[key] = [value]
    end
  end
  # puts first_section

  ret = 0
  second_section.each do |line|
    arr = line.split(',')
    # puts "===\ncurrent line: #{line}\n"
    flag_cnt = true
    while arr.size > 1 && flag_cnt
      key = arr.shift
      value = first_section[key]
      if value.nil?
        # puts "#{key} is not found in the first section"
        # puts "break"
        flag_cnt = false
        break
      end

      arr.each do |v|
        if value.include?(v)
          next
        else
          # puts "#{v} is not found in the #{key}: #{value}"
          # puts "break"
          flag_cnt = false
          break
        end
      end

      # if flag_cnt
      #   puts "#{key} is place in the first section"
      # else
      #   puts "#{key} is not place in the first section"
      # end
    end

    if flag_cnt
      # means all the keys are placed in the first section
      # add the value to the result
      targets = line.split(',')
      target = targets[targets.size / 2]
      # puts "\n targets: #{targets}"
      # puts "target: #{target}"

      ret += target.to_i
    end

    # puts "end of line"
  end

  puts "answer: #{ret}"
end

solution_one(sample_file)
solution_one(puzzle_file)

def solution_two(filename)
  puts filename
  data = File.readlines(filename, chomp: true)
  first_section, second_section = data.slice_when { _1.empty? }.to_a
  first_section.reject!(&:empty?)
  first_section = first_section.each_with_object({}) do |line, hash|
    key, value = line.split('|')
    if hash[key]
      hash[key] << value
    else
      hash[key] = [value]
    end
  end
  # puts first_section

  ret = 0
  # second_section[0, 6].each do |line|
  second_section.each do |line|
    arr = line.split(',')
    # puts "===\ncurrent line: #{line}\n"
    flag_cnt = true
    while arr.size > 1 && flag_cnt
      key = arr.shift
      value = first_section[key]
      if value.nil?
        # puts "#{key} is not found in the first section"
        # puts "break"
        flag_cnt = false
        break
      end

      arr.each do |v|
        if value.include?(v)
          next
        else
          # puts "#{v} is not found in the #{key}: #{value}"
          # puts "break"
          flag_cnt = false
          break
        end
      end

      # if flag_cnt
      #   puts "#{key} is place in the first section"
      # else
      #   puts "#{key} is not place in the first section"
      # end
    end

    if flag_cnt
      # means all the keys are placed in the first section
      # discard then in solution two
    else
      # to correctly the order of the keys, by first_section
      targets = line.split(',')
      counting_arr = targets.map { |target| [target, 0] }.to_h
      targets.each do |target|
        first_section.each do |key, value|
          if targets.include?(key) && value.include?(target)
            counting_arr[target] += 1
          end
        end
      end
      targets.sort_by! { |target| counting_arr[target] }

      # puts "line:   #{line}"
      # puts "sorted: #{targets.join(',')}"
      # puts "counting: #{counting_arr.sort_by { |k, v| -v }.to_h}"


      # puts "line:   #{line}"
      # puts "sorted: #{targets.join(',')}"

      ret += targets.reverse[targets.size / 2].to_i
    end

    # puts "end of line"
  end

  # puts "first section: #{first_section.values.map(&:size).tally}"

  puts "answer: #{ret}"
end

solution_two(sample_file)
solution_two(puzzle_file)
