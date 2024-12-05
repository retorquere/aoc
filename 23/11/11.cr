#!/usr/bin/env crystal

alias Coord = NamedTuple(row: Int128, col: Int128)

class Node
  property id : Int128
  property coord : Coord

  def row
    @coord[:row]
  end
  def col
    @coord[:col]
  end

  def initialize(@id : Int128, @coord : Coord)
  end
end

class Grid
  property height
  property width
  property nodes

  def initialize(@height = 0, @width = 0, @nodes = [] of Node)
  end

  def insert(axis : Symbol, pos : Int128, n : Int128)
    @nodes.each{|node|
      if node.coord[axis] > pos
        node.coord = { row: node.row + (axis == :row ? n : 0), col: node.col + (axis == :col ? n : 0) }
      end
    }
    @height += n if axis == :row
    @width += n if axis == :col
  end

  def empty?(axis : Symbol) : Array(Int128)
    (0...({ row: @height, col: @width }[axis])).select{|pos| @nodes.select{|node| node.coord[axis] == pos}.size == 0}.map{|pos| pos.to_i128}
  end

  def dist(n1, n2)
    (n1.row - n2.row).abs + (n1.col - n2.col).abs
  end
end

def solve(part : Int128, expand : Int128)
  grid = Grid.new
  File.new("input.txt").each_line.with_index do |line, row|
    line.chars.each_with_index do |c, col|
      grid.nodes << Node.new(grid.nodes.size.to_i128 + 1_i128, { row: row.to_i128, col: col.to_i128 }) if c == '#'
    end
  
    grid.width = line.size
    grid.height = row + 1
  end

  [ :row, :col ].each{|axis|
    grid.empty?(axis).sort.reverse.each{|pos|
      grid.insert(axis, pos, expand - 1)
    }
  }

  pairs = grid.nodes.combinations(2).to_a
  puts "part #{part}: #{pairs.map{|pair| grid.dist(pair[0], pair[1]) }.sum}"
end

solve(1, 2)
solve(2, 1000000)
