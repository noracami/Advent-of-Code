def parse(str)
  if str.class.name == "Array"
    {
      Action: "ls",
      content: str.drop(1).map(&:chomp)
    }
  elsif str.start_with? "$ cd .."
    # change to previous directory
    {
      Action: "cd",
      content: nil
    }
  elsif str.start_with? "$ cd"
    # change to specific directory
    /cd (?<folder_name>\w+)/ =~ str
    {
      Action: "cd",
      content: folder_name
    }
  end
end

File.open('day07-input.txt', 'r') { |f|
  f.readline

  # res = f.first 11
  res = f

  res = res.chunk_while { |i, j| !j.start_with? "$"}.map {|_| _.size > 1 ? _ : _.last }
  
  directory = {root: {size: 0, sub_folder: []}}
  current_directory = :root
  previous_directory = []

  res.each { |a|
    _ = parse a
    action, content = _[:Action], _[:content]

    case action
    when "cd"
      if content
        previous_directory << current_directory
        current_directory = "#{current_directory}/#{content}"
        directory[current_directory] = {size: 0, sub_folder: []}
      else
        size = directory[current_directory][:size]
        current_directory = previous_directory.pop
        directory[current_directory][:size] += size
      end
    when "ls"
      content.each { |line|
        /dir (?<folder_name>.+)/ =~ line
        /(?<size>\d+) (?<file_name>.+)/ =~ line

        directory[current_directory][:sub_folder] << folder_name if folder_name
        directory[current_directory][:size] += size.to_i if size
      }
    else
      raise 'error'
    end
  }

  while !previous_directory.empty?
    size = directory[current_directory][:size]
    current_directory = previous_directory.pop
    directory[current_directory][:size] += size
  end

  puts directory.reject { |key, value| value[:size] > 100000 }.sum { |key, value| value[:size] }

  unused_space = 70000000 - directory[:root][:size]
  least_space = 30000000 - unused_space

  puts directory.reject { |key, value| value[:size] < least_space }.min_by { |key, value| value[:size] }
}
