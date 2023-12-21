#!/usr/bin/env crystal

alias Point = Tuple(Int32, Int32)

U = {-1, 0}
R = {0, +1}
D = {+1, 0}
L = {0, -1}

class Garden
  @@plot = Hash(Point, Char).new
  @@height = 0
  @@width = 0
  property plot = Hash(Point, Char).new
  property height = 0
  property width = 0

  def initialize
    if @@plot.size == 0
      File.read("sample.txt").chomp.split("\n").each_with_index do |line, row|
        @@height = row
        line.chars.each_with_index do |plot, col|
          @@width = col
          @@plot[{ row, col }] = plot
        end
      end
    end

    @plot = @@plot.clone
    @height = @@height
    @width = @@width
  end

  def moves(from : Point)
    [ U, R, D, L ].map{|move| { from.first + move.first, from.last + move.last } }.select{|p| @plot.has_key?(p) && @plot[p] != '#' }
  end

  def show(fill : Array(Point))
    (0 ... self.height).each do |row|
      (0 ... self.width).each do |col|
        pos = { row, col }
        print fill.includes?(pos) ? 'O' : @plot[pos]
      end
      puts
    end
    puts
  end
end

garden = Garden.new
reachable = garden.plot.select{|pos, plot| plot == 'S'}.keys.uniq
6.times do
  reachable = reachable.map{|p| garden.moves(p) }.flatten.uniq
  #garden.show(reachable)
end
puts reachable.size

# priemfactoren van 26501365 zijn 5 x 11 x 481843
