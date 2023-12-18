#!/usr/bin/env crystal

require "priority-queue"

alias Coord = Tuple(Int32, Int32)
alias State = Tuple(Int32, Coord, Int32, Int32) # cost, pos, dir, n

Grid = Hash(Coord, Int32).new

File.read("sample.txt").chomp.split("\n").each_with_index do |line, row|
  line.chars.each_with_index do |cost, col|
    Grid[{row, col}] = cost.to_i
  end
end

Moves = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

def solve(min, max)
  open = Priority::Queue(State).new
  open.push(0, {0, Grid.keys.min, 0, 0})
  open.push(0, {0, Grid.keys.min, 1, 0})
  visited = Set(Tuple(Coord, Int32, Int32)).new

  until open.empty?
    cost, current, dir, n = open.pop.value

    next unless visited.add?({current, dir, n})

    if current == Grid.keys.max
      if n >= min
        puts cost
        return
      end
    end

    turn = Moves[dir]
    neighbour = { current[0] + turn[0], current[1] + turn[1] }
    next unless Grid.has_key?(neighbour)

    cost += Grid[neighbour]
    n += 1

    if n < max
      open.push(-cost, { cost, neighbour, dir, n })
    end

    if n >= min
      open.push(-cost, {cost, neighbour, (dir + 1) % 4, 0})
      open.push(-cost, {cost, neighbour, (dir - 1) % 4, 0})
    end
  end
  return -1
end

solve(1, 3)
solve(4, 10)
