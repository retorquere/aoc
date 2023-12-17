#!/usr/bin/env crystal

R = {0, +1}
D = {+1, 0}
L = {0, -1}
U = {-1, 0}

alias Coord = Tuple(Int32, Int32)
alias State = NamedTuple(cost: Int32, cell: Coord, moves: Array(Coord))

Grid = Hash(Coord, Int32).new

File.read("sample.txt").chomp.split("\n").each_with_index do |line, row|
  line.chars.each_with_index do |cost, col|
    Grid[{row, col}] = cost.to_i
  end
end

def search(max_same)
  visited = Set(NamedTuple(cell: Coord, moves: Array(Coord))).new
  open = [{ cost: 0, cell: {0, 0}, moves: [R] }, { cost:0, cell: {0, 0}, moves: [D] }]
  goal = Grid.keys.max

  until open.empty?
    cheapest = open.shift

    next unless visited.add?(NamedTuple(cell: Coord, moves: Array(Coord)).from(cheapest.to_h.reject(:cost)))

    cell = {cheapest[:cell][0] + cheapest[:moves][0][0], cheapest[:cell][1] + cheapest[:moves][0][1]}
    next unless Grid.has_key?(cell)

    cost = cheapest[:cost] + Grid[cell]
    if cheapest[:moves].size <= max_same
      return cost if cell == goal
    end

    [R, D, L, U].each do |move|
      # can't reverse
      next if move.to_a.zip(cheapest[:moves][0].to_a).map{|dir| dir.sum}.uniq == [0]
      moves = cheapest[:moves][0] == move ? [ move ] + cheapest[:moves] : [ move ]
      next if moves.size > max_same
      open << { cost: cost, cell: cell, moves: moves }
    end
    open.sort_by!{|state| state[:cost]}
  end
end

puts search(3)
