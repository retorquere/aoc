#!/usr/bin/env crystal

lines = [] of Array(Int32)
File.each_line("input.txt") {|line|
  lines << line.split.map{|n| n.to_i32}
}

def solve(line : Array(Int32), pos : Int32, factor : Int32)
  lines = [ line ]
  while line.uniq.size != 1
    line = line.each_cons(2).to_a.map{|pair| factor * (pair[1] - pair[0]).as(Int32) }
    lines << line
  end
  return lines.map{|line| line[pos]}.sum
end

puts lines.map{|line| solve(line, -1, 1) }.sum
puts lines.map{|line| solve(line, 0, -1) }.sum
