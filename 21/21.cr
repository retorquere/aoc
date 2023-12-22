#!/usr/bin/env crystal

require "../util"
require "json"

# idx3 = str.index('o').not_nil!

alias Point = Tuple(Int32, Int32)

U = {-1, 0}
R = {0, +1}
D = {+1, 0}
L = {0, -1}

Grid = File.read((ARGV + ["sample"]).first.sub(/[.]txt$/, "") + ".txt").chomp.split("\n")
Rows = Grid.size
Cols = Grid[0].size
Start = Grid.map_with_index{|row, r|
  row.chars.map_with_index{|cell, c|
    { { r, c }, cell }
  }
  }.flatten.find{|cell| cell[1] == 'S'}.not_nil![0]

def reachable(steps)
  reachable = [ Start ]
  steps.times do
    reachable = reachable.map{|cell|
      [ U, R, D, L ].map{|move|
        { cell.first + move.first, cell.last + move.last }
      }.select{|cell|
        Grid[cell.first % Rows][cell.last % Cols] != '#'
      }
    }.flatten.uniq
  end

  return reachable.size
end

puts reachable(6)

#print(reachable(400))
#
#class Garden
#  property start = { 0, 0 }
#  property height = 0
#  property width = 0
#  property grid : Array(Array(Char)) = [] of Array(Char)
#
#  def initialize(@infinite : Bool = false)
#    input = (ARGV + ["sample"]).first
#    input += ".txt" unless input.ends_with?(".txt")
#
#    @grid = File.read(input).chomp.split("\n").map{|line| line.chars}
#
#    @height = grid.size
#    @rows = (0 ... @height)
#    @width = grid[0].size
#    @cols = (0 ... @width)
#
#    @rows.each do |row|
#      @cols.each do |col|
#        @start = { row, col } if @grid[row][col] == 'S'
#      end
#    end
#  end
#
#  def nodes
#    @rows.map{|row| @cols.map{|col| { row, col }}}.flatten.select{|p| self.has_key?(p)}
#  end
#
#  def translate(p : Point)
#    if @infinite
#      return { p.first % @height, p.last % @width }
#    else
#      return p
#    end
#  end
#
#  def has_key?(p : Point)
#    row, col = self.translate(p)
#    return false unless @rows.covers?(row) && @cols.covers?(col)
#    return @grid[row][col] != '#'
#  end
#
#  def neighbours(p : Point, closed : Bool = false)
#    return [ U, R, D, L ].map{|dir|
#      { p.first + dir.first, p.last + dir.last }
#    }.map{|p|
#      @infinite && closed ? self.translate(p) : p
#    }.select{|p| self.has_key?(p)}
#  end
#
#  def reachable(steps : Int64) : Array(Point)
#    tally = {} of Int32 => Array(Int64)
#    reachable = [ @start ]
#    steps.times do |step|
#      transition = "#{reachable.size} => "
#      reachable = reachable.map{|p| self.neighbours(p) }.flatten.uniq
#      transition += "#{reachable.size}"
#      puts transition
#
#      tally[reachable.size] = tally[reachable.size]? || [] of Int64
#      tally[reachable.size] << step
#    end
#    File.open("#{steps}.csv", "w") do |f|
#      tally.keys.sort.each do |size|
#        f.puts(([size] + tally[size]).map{|n| n.to_s}.join(","))
#      end
#    end
#    return reachable
#  end
#
#  def show(filename : String, reached : Array(Point))
#    box = 10
#
#    top = reached.map{|n| n.first}.min
#    left = reached.map{|n| n.last}.min
#    reached = reached.map{|r, c| { r - top, c - left } }
#
#    height = ([@height] + reached.map{|n| n.first}).max
#    width = ([@width] + reached.map{|n| n.last}).max
#    puts "#{filename} h=#{height} w=#{width}"
#
#    File.open(filename, "w") do |f|
#      f.puts("<svg viewBox=\"0 0 #{height * box} #{width * box}\" xmlns=\"http://www.w3.org/2000/svg\">")
#      (0 ... height).each do |row|
#        (0 ... width).each do |col|
#          if reached.includes?({ row, col })
#            color = "green"
#          else
#            gr, gc = self.translate({ row, col })
#            if @grid[gc][gr] == '#'
#              color = "red"
#            else
#              color = "white"
#            end
#          end
#          f.puts("<rect x=\"#{row * box}\" y=\"#{col * box}\" width=\"#{box}\" height=\"#{box}\" style=\"fill:#{color}\" />")
#        end
#      end
#      f.puts("<rect x=\"#{@start.first * box}\" y=\"#{@start.last * box}\" width=\"#{box}\" height=\"#{box}\" style=\"fill:blue\" />")
#      f.puts("</svg>")
#    end
##    puts fill
##    (0 ... @height).each do |row|
##      (0 ... @width).each do |col|
##        pos = { row, col }
##        print fill.includes?(pos) ? 'O' : @grid[row][col]
##      end
##      puts
##    end
##    puts
#  end
#
#  def name(p : Point) : String
#    return p == @start ? "S" : "#{p.first}x#{p.last}"
#  end
#
#  def gml
#    g = GML.new
#    @rows.each do |row|
#      @cols.each do |col|
#        next unless self.has_key?({ row, col })
#        g.node(self.name({ row, col }))
#      end
#    end
#    g.color(self.name(@start), "#00FF00")
#    @rows.each do |row|
#      @cols.each do |col|
#        next unless self.has_key?({ row, col })
#        p = { row, col }
#        self.neighbours(p, true).each do |n|
#          g.edge(self.name(p), self.name(n))
#        end
#      end
#    end
#    g.write("21.gml")
#  end
#end
#
#
#garden = Garden.new
#garden.show("0.svg", [ garden.start ])
#garden.gml
#puts "part 1: #{garden.reachable(6).size}"
#
## priemfactoren van 26501365 zijn 5 x 11 x 481843
#
#arden = Garden.new(true)
#[3].each do |steps|
#  garden.show("#{steps}.svg", garden.reachable(steps))
#end
