#!/usr/bin/env crystal

require "priority-queue"

R = {0, +1}
D = {+1, 0}
L = {0, -1}
U = {-1, 0}

alias Coord = Tuple(Int32, Int32)
alias Candidate = Tuple(Int32, Coord, Coord, Int32)
alias State = Tuple(Coord, Coord, Int32)

Grid = Hash(Coord, Int32).new

File.read("input.txt").chomp.split("\n").each_with_index do |line, row|
  line.chars.each_with_index do |cost, col|
    Grid[{row, col}] = cost.to_i
  end
end

def search(min, max)
  visited = Set(State).new
  open = Priority::Queue(Candidate).new
  [{ 0, Grid.keys.min, R, 1 }, { 0, Grid.keys.min, D, 1 }].each do |o|
    open.push(0, o)
  end
  goal = Grid.keys.max

  until open.empty?
    cost, current, dir, n = open.pop.value

    next unless visited.add?({ current, dir, n })

    neighbour = {current[0] + dir[0], current[1] + dir[1]}
    next unless Grid.has_key?(neighbour)

    cost += Grid[neighbour]
    return cost if neighbour == goal && n >= min && n <= max

    [R, D, L, U].each do |move|
      # can't reverse
      next if { dir[0] + move[0], dir[1] + move[1] } == {0, 0}

      # no turn unless min distance covered
      next if move != dir && n < min

      # don't proceed if crucible gets wobbly
      move_n = dir == move ? n + 1 : 1
      next if move_n > max

      open.push(-cost, { cost, neighbour, move, move_n })
    end
  end
  return -1
end

puts search(1, 3)
puts search(4, 10)
