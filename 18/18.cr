#!/usr/bin/env crystal

Move = {
  'U' => { 0_i64, -1_i64 },
  '3' => { 0_i64, -1_i64 },
  'R' => { +1_i64, 0_i64 },
  '0' => { +1_i64, 0_i64 },
  'D' => { 0_i64, +1_i64 },
  '1' => { 0_i64, +1_i64 },
  'L' => { -1_i64, 0_i64 },
  '2' => { -1_i64, 0_i64 },
}

class Point
  property x
  property y
  def initialize(coord : Tuple(Int64, Int64))
    @x, @y = coord
  end

  def shoelace(other)
    self.x * other.y - self.y * other.x
  end

  def manhattan(other)
    (self.x - other.x).abs + (self.y - other.y).abs
  end

  def move(dir : Tuple(Int64, Int64), steps : Int64) : Point
    return Point.new({ self.x + (dir[0] * steps), self.y + (dir[1] * steps) })
  end
end

Part1 = [ Point.new({0_i64, 0_i64}) ]
Part2 = [ Point.new({0_i64, 0_i64}) ]

File.read("input.txt").chomp.split("\n").each{ |line|
  line.match(/^([UDLR]) ([0-9]+) .#([a-zA-Z0-9]{5})([0-3])/)
  Part1 << Part1[-1].move(Move[$1[0]], $2.to_i64)
  Part2 << Part2[-1].move(Move[$4[0]], $3.to_i64(16))
}

def svg(path : Array(Point), filename : String)
  xmin = path.map{|p| p.x}.min
  ymin = path.map{|p| p.y}.min
  path = path.map{|p| p.move({ -xmin, -ymin }, 1)}
  xmax = path.map{|p| p.x}.max
  ymax = path.map{|p| p.y}.max
  File.open(filename, "w") do |f|
    f.print("<svg viewBox=\"0 0 #{xmax} #{ymax}\" xmlns=\"http://www.w3.org/2000/svg\">\n<polygon points=\"")
    f.print(path[0...-1].map{|p| "#{p.x},#{p.y}"}.join(" "))
    f.puts("\" fill=\"none\" stroke=\"black\" />")
    f.puts("</svg>")
  end

  #puts "<rect x=\"#{x}\" y=\"#{y}\" width=\"#{n.size}\" height=\"1\" style=\"fill:rgb(255,0,0)\" />"
end

def shoelace_plus_border(path : Array(Point)) : Int64
  # https://rosettacode.org/wiki/Shoelace_formula_for_polygonal_area

  area = path.each_cons(2).sum{|edge| edge[0].shoelace(edge[1]) }.abs // 2
  border = path.each_cons(2).sum{|edge| edge[0].manhattan(edge[1]) } // 2 # why by 2?
  return area + border + 1 # why + 1?
end

puts shoelace_plus_border(Part1)
puts shoelace_plus_border(Part2)

svg(Part1, "part1.svg")
svg(Part2, "part2.svg")
