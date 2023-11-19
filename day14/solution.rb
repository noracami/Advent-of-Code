# frozen_string_literal: true

require './utils'

class Solution
  extend Utils

  def self.part1
    filename = './day14/part1-sample.txt'
    # filename = './day14/part1-input.txt'
    res = parse_input(filename)

    maps =
      (0..200).each_with_object({}) do |row, obj|
        (461..519).each do |column|
          obj["#{column}, #{row}"] = '.'
        end
      end

    maps['500, 0'] = '+'
    res
      .map { |line| line.split(' -> ').map { |el| el.split(',').map(&:to_i) } }
      .each do |line|
      line.each_cons(2) do |prev, nxt|
        if prev[0] == nxt[0]
          rows = prev[1] >= nxt[1] ? nxt[1]..prev[1] : prev[1]..nxt[1]
          rows.each { |row| maps["#{prev[0]}, #{row}"] = '#' }
        elsif prev[1] == nxt[1]
          columns = prev[0] >= nxt[0] ? nxt[0]..prev[0] : (prev[0]..nxt[0])
          columns.each { |column| maps["#{column}, #{prev[1]}"] = '#' }
        end
      end
    end

    answer = maps

    163.times do |row|
      (461..519).each { |column| print answer["#{column}, #{row}"] }
      puts row
    end
  end
end
