#!/usr/bin/env crystal

alias Point = Array(Int32)
X = 0
Y = 1
Z = 2
B = 0
E = 1

TH = 0
TB = 1

Bricks = File.read("input.txt").chomp.split("\n").map{ |line|
  Tuple(Point, Point).from(line.split("~").map{|c| c.split(",").map{|n| n.to_i} })
}.sort_by{|b| b[B][Z]}

Top = Hash(Tuple(Int32, Int32), Tuple(Int32, Int32)).new{ { 0, -1 } } # height, brick
Graph = Bricks.map{ [] of Int32 }
Required = Set(Int32).new

Bricks.each_with_index do |brick, id|
  maxheight = -1
  support = Set(Int32).new
  (brick[B][X] .. brick[E][X]).each do |x|
    (brick[B][Y] .. brick[E][Y]).each do |y|
      if Top[{ x, y }][TH] + 1 > maxheight
        maxheight = Top[{ x, y }][TH] + 1
        support = Set{ Top[{ x, y }][TB] }

      elsif Top[{ x, y }][TH] + 1 == maxheight
        support.add(Top[{ x, y }][TB])

      end
    end
  end

  support.each do |x|
    Graph[x] << id if x != -1
  end

  Required.add(support.to_a[0]) if support.size == 1
  
  fall = brick[B][Z] - maxheight
  if fall > 0
    brick[B][Z] -= fall
    brick[E][Z] -= fall
  end

  (brick[B][X] .. brick[E][X]).each do |x|
    (brick[B][Y] .. brick[E][Y]).each do |y|
      Top[{ x, y }] = { brick[E][Z], id }
    end
  end
end

puts Bricks.size - (Required.size - 1)

def damage(brick)
  ind = [0] * Bricks.size
  (0...Bricks.size).each do |j|
    Graph[j].each do |i|
      ind[i] += 1
    end
  end
  queue = [brick]
  fall = -1
  until queue.empty?
    fall += 1
    top = queue.pop()
    Graph[top].each do |i|
      ind[i] -= 1
      queue << i if ind[i] == 0
    end
  end

  return fall
end

puts (0...Bricks.size).map{|brick| damage(brick) }.sum
