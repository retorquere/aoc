#!/usr/bin/env crystal

alias Point = Tuple(Int32, Int32)

U = {-1, 0}
R = {0, +1}
D = {+1, 0}
L = {0, -1}

class Garden
  property neighbours = Hash(Point, Array(Point)).new
  property start = { 0, 0 }
  property height = 0
  property width = 0

  def initialize(infinite : Bool = false)
    grid = File.read("sample.txt").chomp.split("\n").map{|line| line.chars}
    @height = grid.size
    rows = (0 ... @height)
    @width = grid[0].size
    cols = (0 ... @width)

    rows.each do |row|
      cols.each do |col|
        @start = { row, col } if grid[row][col] == 'S'
        @neighbours[{ row, col }] = [ U, R, D, L ].map{|move|
          pos = { row + move.first, col + move.last }
          pos = { pos.first % @height, pos.last % @width } if infinite
          if rows.covers?(pos.first) && cols.covers?(pos.last) && grid[pos.first][pos.last] != '#'
            [ pos ]
          else
            [] of Point
          end
        }.flatten
      end
    end
  end

  def show(fill : Array(Point))
    (0 ... @height).each do |row|
      (0 ... @width).each do |col|
        pos = { row, col }
        print fill.includes?(pos) ? 'O' : @plot[pos]
      end
      puts
    end
    puts
  end
end

garden = Garden.new
reachable = [ garden.start ]
6.times do
  reachable = reachable.map{|p| garden.neighbours[p] }.flatten.uniq
  #garden.show(reachable)
end
puts reachable.size

# priemfactoren van 26501365 zijn 5 x 11 x 481843
