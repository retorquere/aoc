#!/usr/bin/env crystal

R = {0, +1}
D = {+1, 0}
L = {0, -1}
U = {-1, 0}

alias Coord = Tuple(Int32, Int32)
alias State = NamedTuple(cost: Int32, cell: Coord, dir: Coord, n: Int32)

Grid = Hash(Coord, Int32).new

File.read("sample.txt").chomp.split("\n").each_with_index do |line, row|
  line.chars.each_with_index do |cost, col|
    Grid[{row, col}] = cost.to_i
  end
end

def search(max_same)
  visited = Set(NamedTuple(cell: Coord, dir: Coord, n: Int32)).new
  open = [{ cost: 0, cell: {0, 0}, dir: R, n:1 }, { cost:0, cell: {0, 0}, dir: D, n: 1 }]
  goal = Grid.keys.max

  until open.empty?
    cheapest = open.shift

    next unless visited.add?(NamedTuple(cell: Coord, dir: Coord, n: Int32).from(cheapest.to_h.reject(:cost)))

    cell = {cheapest[:cell][0] + cheapest[:dir][0], cheapest[:cell][1] + cheapest[:dir][1]}
    next unless Grid.has_key?(cell)

    cost = cheapest[:cost] + Grid[cell]
    if cheapest[:n] <= max_same
      return cost if cell == goal
    end

    [R, D, L, U].each do |dir|
      # can't reverse
      next if dir.to_a.zip(cheapest[:dir].to_a).map{|move| move.sum}.uniq == [0]
      n = cheapest[:dir] == dir ? cheapest[:n] + 1 : 1
      next if n > max_same
      open << { cost: cost, cell: cell, dir: dir, n: n }
    end
    open.sort_by!{|state| state[:cost]}
  end
end

puts search(3)
