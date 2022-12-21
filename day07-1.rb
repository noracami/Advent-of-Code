class Folder
  attr_accessor :name, :size
  
  def initialize(name="")
    @name = name
    @size = 0
    @sub_folder = []
    @files = []
  end

  def << item
    _ = item
    name, size = _[:name], _[:size]
    if size
      @files << {name:, size:}
      @size += size.to_i
    else
      @sub_folder << Folder.new(name)
    end
  end

  def to_s
    if @sub_folder.empty?
      "name: #{@name}, size: #{@size}"
    else
      sub_folder = @sub_folder.map(&:to_s)
      "name: #{@name}, size: #{@size}, sub_folder: #{sub_folder}"
    end
  end
end

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

  tree = Folder.new("root")
  current_directory = 0

  res = f.first 20

  res = res.chunk_while { |i, j| !j.start_with? "$"}.map {|_| _.size > 1 ? _ : _.last }
  
  res.each { |a|
    _ = parse a
    action, content = _[:Action], _[:content]

    case action
    when "cd"
      if content
      else
      end
    when "ls"
      content.each { |line|
        /dir (?<folder_name>\w+)/ =~ line
        /(?<size>\d+) (?<file_name>.+)/ =~ line
        tree << { name: folder_name } if folder_name
        tree << { name: file_name, size: } if size
      }
    else
      raise 'error'
    end
  }
  puts tree
}
