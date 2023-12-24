#!/usr/bin/env crystal

alias Point = Tuple(Float64, Float64, Float64)
alias Vector = Tuple(Float64, Float64, Float64)

class Stone
  property origin : Point
  property v : Vector

  def initialize(stone : String)
    @origin, @v = stone.split("@").map{|pv| Point.from(pv.split(",").map{|p| p.chomp.to_f}) }
  end

  def intercept(other : Stone) : Tuple(Point, Float64, Float64)
    det = @v[0]*other.v[1] - @v[1]*other.v[0]

    #return Nil, Nil, Nil if det == 0

    t1 = ((other.origin[0] - @origin[0]) *other.v[1] - (other.origin[1] - @origin[1]) * other.v[0]) / det
    t2 = ((other.origin[0] - @origin[0]) *@v[1] - (other.origin[1] - @origin[1]) * @v[0]) / det

    return { { @origin[0] + t1 * @v[0], @origin[1] + t1 * @v[1], 0.0 }, t1, t2 }
  end

  def name
    return "#{@origin[0]}x#{@origin[1]}"
  end
end

Stones = File.read((ARGV + ["sample"]).first.sub(/[.]txt$/, "") + ".txt").chomp.split("\n").map{|stone|
  Stone.new(stone)
}

#Area = { 7.0, 27.0 }
Area = { 200000000000000.0, 400000000000000.0 }
intersections = 0
Stones.each_with_index{|a, i|
  Stones[(i+1)..].each{|b|
    p, ta, tb = a.intercept(b)
    x, y = p
    if x.infinite?
      #puts "#{a.name} - #{b.name} do not cross"
    elsif x != x.clamp(Area[0], Area[1]) || y != y.clamp(Area[0], Area[1])
      #puts "#{a.name} - #{b.name} cross outside the test area"
    elsif ta < 0 || tb < 0
      #puts "#{a.name} - #{b.name} cross in the past"
    else
      #puts "#{a.name} - #{b.name} cross at #{p}"
      intersections += 1
    end
  }
}
puts intersections
