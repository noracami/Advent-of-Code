File.open('day11-input.txt', 'r') { |f|
  res = f
  
  res = res.chunk_while { |i, j| !j.start_with? "Monkey"}.map {|_| _.map(&:chomp) }

  parse = -> arr {
    res = {}
    arr.each { |line|
      /Monkey (?<monkey_no>\d)/ =~ line
      /Starting items: (?<items_list>[\d, ]+)/ =~ line
      /Operation: new = old (?<operator>[+*]) (?<operand>.+)/ =~ line
      /Test: divisible by (?<modulo>\d+)/ =~ line
      /If true: throw to monkey (?<truthy_destination>\d+)/ =~ line
      /If false: throw to monkey (?<falsy_destination>\d+)/ =~ line

      
      res[:items_list] = items_list.scan /\d+/ if items_list

      res[:monkey_no] = monkey_no if monkey_no
      res[:operator] = operator if operator
      res[:operand] = operand if operand
      res[:modulo] = modulo if modulo
      res[:truthy_destination] = truthy_destination if truthy_destination
      res[:falsy_destination] = falsy_destination if falsy_destination
    }
    res
  }  

  # puts res.map(&parse)
  monkeys = res.map(&parse)


  cycles = 25

  (1..cycles).each { |i|
    mm = monkeys.each
    while monkey = mm.next

  }
}
