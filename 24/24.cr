#!/usr/bin/env crystal
require "../util"

alias Point = Tuple(Int64, Int64, Int64)
alias FloatingPoint = Tuple(Float64, Float64, Float64)
alias Vector = Tuple(Int64, Int64, Int64)

class Stone
  property origin : Point
  property v : Vector

  def initialize(stone : String)
    @origin, @v = stone.split("@").map{|pv| Point.from(pv.split(",").map{|p| p.chomp.to_i64}) }
  end

  def x; @origin[0]; end
  def y; @origin[1]; end
  def z; @origin[2]; end
  def vx; @v[0]; end
  def vy; @v[1]; end
  def vz; @v[2]; end

  def intersectxy(other : Stone) : Tuple(FloatingPoint, Float64, Float64)
    det = @v[0]*other.v[1] - @v[1]*other.v[0]

    #return Nil, Nil, Nil if det == 0

    t1 = ((other.origin[0] - @origin[0]) *other.v[1] - (other.origin[1] - @origin[1]) * other.v[0]) / det
    t2 = ((other.origin[0] - @origin[0]) *@v[1] - (other.origin[1] - @origin[1]) * @v[0]) / det

    return { { @origin[0] + t1 * @v[0], @origin[1] + t1 * @v[1], 0.0 }, t1, t2 }
  end
end

Stones = File.read((ARGV + ["input"]).first.sub(/[.]txt$/, "") + ".txt").chomp.split("\n").map{|stone|
  Stone.new(stone)
}

#Area = { 7.0, 27.0 }
Area = { 200000000000000.0, 400000000000000.0 }
intersections = 0
Stones.each_with_index do |a, i|
  Stones[(i+1)..].each do |b|
    p, ta, tb = a.intersectxy(b)
    x, y = p
    if x.infinite?
      #puts "#{a.name} - #{b.name} do not cross"
    elsif x != x.clamp(Area[0], Area[1]) || y != y.clamp(Area[0], Area[1])
      #puts "#{a.name} - #{b.name} cross outside the test area"
    elsif ta < 0 || tb < 0
      #puts "#{a.name} - #{b.name} cross in the past"
    #elsif ta.integer? && tb.integer?
      #puts "#{a.name} - #{b.name} cross at #{p}"
    else
      #puts "#{a.name} - #{b.name} cross at #{p}"
      intersections += 1
    end
  end
end
puts intersections

Velocities = [
  Hash(Int64, Array(Int64)).new,
  Hash(Int64, Array(Int64)).new,
  Hash(Int64, Array(Int64)).new,
]
(0..2).each do |axis|
  Stones.each do |stone|
    v = stone.v[axis]
    Velocities[axis][v] = [] of Int64 unless Velocities[axis][v]?
    Velocities[axis][v] << stone.origin[axis]
  end
end

Rock = Stone.new("0,0,0@0,0,0")
Rock.v = {0, 1, 2}.map{ |axis|
  min = Stones.map{|stone| stone.v[axis]}.min - 100
  max = Stones.map{|stone| stone.v[axis]}.max + 100

  candidates = (min .. max).to_a
  Velocities[axis].each do |v, origin|
    next unless origin.size >= 2
    candidates = candidates.select{|cv| (cv != v) && ((origin[0] - origin[1]) % (cv - v)) == 0 }
  end
  candidates.first
}

results = Hash(Int128, Int128).new(0_i128)
Stones.each_with_index do |a, i|
  Stones[(i+1)..].each do |b|
    # slope and intercept wrt rock x/y
    ma = (a.vy - Rock.vy) / (a.vx - Rock.vx)
    ia = a.y - (ma * a.x)
    mb = (b.vy - Rock.vy) / (b.vx - Rock.vx)
    ib = b.y - (mb * b.x)
    
    # x/y from top-projection
    rpx = ((ib-ia) / (ma-mb)).to_i128
    rpy = (ma*rpx + ia).to_i128
    
    time = ((rpx - a.x) / (a.vx - Rock.vx)).round
    rpz = a.z + (a.vz - Rock.vz) * time

    raise "not int" unless [rpx, rpy, rpz].all?{|n| n.integer? }
    
    result = rpx.to_i128 + rpy.to_i128 + rpz.to_i128
    results[result] += 1
  end
end

puts results.to_a.sort_by { |k, v| -v }[0][0]
