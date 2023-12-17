#!/usr/bin/env crystal

require "priority-queue"

R = {0, +1}
D = {+1, 0}
L = {0, -1}
U = {-1, 0}

alias Coord = Tuple(Int32, Int32)
alias Open = NamedTuple(cost: Int32, cell: Coord, move: Coord, n: Int32)

Grid = Hash(Coord, Int32).new

File.read("input.txt").chomp.split("\n").each_with_index do |line, row|
  line.chars.each_with_index do |cost, col|
    Grid[{row, col}] = cost.to_i
  end
end

def search(max_same)
  visited = Set(NamedTuple(cell: Coord, move: Coord, n: Int32)).new
  open = Priority::Queue(Open).new
  [{ cost: 0, cell: {0, 0}, move: R, n: 1 }, { cost:0, cell: {0, 0}, move: D, n: 1 }].each do |o|
    open.push(-o[:cost], o)
  end
  goal = Grid.keys.max

  until open.empty?
    cheapest = open.pop.value

    next unless visited.add?({ cell: cheapest[:cell], move: cheapest[:move], n: cheapest[:n] })

    cell = {cheapest[:cell][0] + cheapest[:move][0], cheapest[:cell][1] + cheapest[:move][1]}
    next unless Grid.has_key?(cell)

    cost = cheapest[:cost] + Grid[cell]
    if cheapest[:n] <= max_same
      return cost if cell == goal
    end

    [R, D, L, U].each do |move|
      # can't reverse
      next if move.to_a.zip(cheapest[:move].to_a).map{|dir| dir.sum}.uniq == [0]
      n = cheapest[:move] == move ? cheapest[:n] + 1 : 1
      next if n > max_same
      open.push(-cost, { cost: cost, cell: cell, move: move, n: n })
    end
  end
end

puts search(3)
