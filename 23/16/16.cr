#!/usr/bin/env crystal

U = {-1, 0}
R = {0, +1}
D = {+1, 0}
L = {0, -1}

Row = 0
Col = 1

alias Move = Tuple(Int32, Int32)

class Tile
  property row
  property col
  property mirror
  property entered : Set(Move)

  def initialize(@row : Int32, @col : Int32, @mirror : Char)
    @entered = Set(Move).new
  end

  def reset
    @entered = Set(Move).new
  end

  def enter(move : Move) : Array(Move)
    return [] of Move if !@entered.add?(move)
    
    case @mirror
    when '.'
      return [ { move[Row], move[Col] } ]

    when '-'
      if move[Row] == 0
        return [ { move[Row], move[Col] } ]
      else
        return [ R, L ]
      end

    when '|'
      if move[Col] == 0
        return [ { move[Row], move[Col] } ]
      else
        return [ U, D ]
      end

    when '/'
      return [ { - move[Col], - move[Row] } ]

    when '\\'
      return [ { move[Col], move[Row] } ]

    else
      raise "invalid move #{move}"

    end
  end

  def energized
    return @entered.size > 0 ? 1 : 0
  end
end

class SGrid
  property tiles : Array(Array(Tile))

  def initialize
    @tiles = File.read("input.txt").chomp.split("\n").map_with_index{ |line, row|
      line.chars.map_with_index{ |mirror, col| Tile.new(row, col, mirror) }
    }
  end

  def height
    @tiles.size
  end

  def width
    @tiles[0].size
  end

  def energize(moves : Array(Tuple(Tile, Move)) = [ { @tiles[0][0], R } ])
    @tiles.each do |row|
      row.each do |tile|
        tile.reset
      end
    end

    while !moves.empty?
      tile, move = moves.pop
      moves += tile.enter(move).map{ |m|
        row = tile.row + m[0]
        col = tile.col + m[1]
        if row < 0 || row >= self.height || col < 0 || col >= self.width
          nil
        else
          { @tiles[row][col], m }
        end
      }.compact
      #self.show
    end

    return tiles.map{ |row| row.map{ |tile| tile.energized }.sum }.sum
  end

  def maximize
    moves : Array(Tuple(Tile, Move)) = [] of Tuple(Tile, Move)

    # top row
    moves << { @tiles[0][0], R }
    moves << { @tiles[0][0], D }
    (1..(self.width - 2)).each do |col|
      moves << { @tiles[0][col], D }
    end
    moves << { @tiles[0][self.width - 1], L }
    moves << { @tiles[0][self.width - 1], D }

    # other rows
    (1..(self.height - 2)).each do |row|
      moves << { @tiles[row][0], R }
      moves << { @tiles[row][self.width - 1], L }
    end

    # bottom row
    moves << { @tiles[self.height - 1][0], R }
    moves << { @tiles[self.height - 1][0], U }
    (1..(self.width - 2)).each do |col|
      moves << { @tiles[self.height - 1][col], U }
    end
    moves << { @tiles[self.height - 1][self.width - 1], L }
    moves << { @tiles[self.height - 1][self.width - 1], U }
    puts moves.map{ |start| self.energize([start]) }.max
  end

  def show
    puts "=" * @tiles[0].size
    @tiles.each { |row|
      row.each{ |tile|
        print ['.', '#'][tile.energized]
      }
      puts
    }
  end
end

Grid = SGrid.new
puts Grid.energize
puts Grid.maximize
