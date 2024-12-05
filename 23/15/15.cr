#!/usr/bin/env crystal

#puts "part 1: #{File.read("input.txt").gsub("\n", "").split(",").map{|instr| instr.each_byte.to_a.reduce(0){|acc, n| ((acc + n) * 17) % 256 } }.sum}"

input = File.read("input.txt").gsub("\n", "").split(",")

def boxid(s : String)
  s.each_byte.to_a.reduce(0){|acc, n| ((acc + n) * 17) % 256 }
end

puts "part 1: #{input.map{|instr| boxid(instr) }.sum}"

class Step
  property lens
  property op
  property focal_length

  @lens : String
  @op : String
  @focal_length : Int32

  def initialize(step : String)
    step.match(/^([a-z]+)([-=])([0-9]*)/i)
    @lens = $1
    @op = $2
    @focal_length = $3.size > 0 ? $3.to_i : -1
  end

  def box
    boxid(@lens)
  end
end

class Lens
  property name
  property focal_length

  def initialize(@name : String, @focal_length : Int32)
  end

  def power(box : Int32, slot : Int32)
    return box * slot * @focal_length
  end

  def to_s
    "[#{@name} #{@focal_length}]"
  end
  def to_str
    self.to_s
  end
end

class LensBox
  property box : Int32
  property lenses : Array(Lens)

  def initialize(@box : Int32)
    @lenses = [] of Lens
  end

  def apply(step : Step)
    case step.op
    when "-"
      @lenses = @lenses.select{|lens| lens.name != step.lens }
    when "="
      newlens = Lens.new(step.lens, step.focal_length)
      @lenses = @lenses.map{|lens| lens.name == step.lens ? newlens : lens }
      @lenses << newlens if !@lenses.any?{ |lens| lens.name == step.lens }
    end
  end

  def size
    @lenses.size
  end

  def to_s
    "Box #{@box}: #{@lenses.map{ | lens | lens.to_s }.join(" ")} @ #{self.power}"
  end

  def to_str
    self.to_s
  end

  def power
    @lenses.map_with_index{ |lens, i| lens.power(@box + 1, i + 1) }.sum
  end
end

boxes = (0...256).to_a.map_with_index{ |id| LensBox.new(id) }
steps = input.map{|step| Step.new(step) }

steps.each do |step|
  boxes[step.box].apply(step)
#  puts "=="
#  boxes.each_with_index do |box, i|
#    puts box.to_s if box.size != 0
#  end
end

puts "part 2: #{boxes.map{ |box| box.power }.sum}"
