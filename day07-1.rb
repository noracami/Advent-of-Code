class Folder
  attr_accessor :name, :size
  
  def initialize(name="")
    @name = name
    @size = 0
    @sub_folder = []
    @files = []
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
  elsif str.start_with? "$ cd /"
    # change to root directory
    {
      Action: "cd",
      content: "root"
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
  tree = []
  current_directory = 0

  res = f.first 21

  res = res.chunk_while { |i, j| !j.start_with? "$"}.map {|_| _.size > 1 ? _ : _.last }
  
  res.each { |a|
    _ = parse a
    action, content = _[:Action], _[:content]

    case action
    when "cd"
      if content
        tree[0] << Folder.new(content)
        current_directory += 1
      else
      end
    when "ls"
      puts "ls"
    else
      raise 'error'
    end
  }
}
