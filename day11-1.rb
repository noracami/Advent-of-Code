File.open('day11-input.txt', 'r') { |f|
  res = f
  
  res = res.chunk_while { |i, j| !j.start_with? "Monkey" }.map { |_| _.map(&:chomp) }

  parse = -> arr {
    res = {}
    arr.each { |line|
      /Monkey (?<monkey_no>\d)/ =~ line
      /Starting items: (?<items_list>[\d, ]+)/ =~ line
      /Operation: new = old (?<operator>[+*]) (?<operand>.+)/ =~ line
      /Test: divisible by (?<modulo>\d+)/ =~ line
      /If true: throw to monkey (?<truthy_destination>\d+)/ =~ line
      /If false: throw to monkey (?<falsy_destination>\d+)/ =~ line
      
      res[:items_list] = items_list.scan(/\d+/).map(&:to_i) if items_list

      res[:monkey_no] = monkey_no if monkey_no
      res[:operator] = operator if operator
      res[:operand] = operand.to_i.nonzero? ? operand.to_i : "old" if operand
      res[:modulo] = modulo.to_i if modulo
      res[:truthy_destination] = truthy_destination.to_i if truthy_destination
      res[:falsy_destination] = falsy_destination.to_i if falsy_destination

      res[:counter] = 0
    }
    res
  }  

  monkeys = res.map(&parse)
  # monkeys = monkeys[0, 1]

  cycles = 20

  (1..cycles).each { |c|
    monkeys.each { |monkey|
      while !monkey[:items_list].empty?
        monkey[:counter] += 1
        item = monkey[:items_list].pop
        operand = monkey[:operand] == "old" ? item : monkey[:operand]
        
        case monkey[:operator]
        when "+"
          item += operand
        when "*"
          item *= operand
        else
          raise :error
        end

        item /= 3

        if (item % monkey[:modulo]).zero?
          monkeys[monkey[:truthy_destination]][:items_list] << item
        else
          monkeys[monkey[:falsy_destination]][:items_list] << item
        end
      end
    }
  }
  puts monkeys.max_by(2) { |m| m[:counter] }.inject(1) { |memo, monkey| memo * monkey[:counter] }
}
