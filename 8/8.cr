#!/usr/bin/env crystal

#struct Node
#  @@map = Hash(String, Tuple(String, String)).new
#
#  property name
#  property steps
#
#  def initialize(@name : String, left : String, right : String)
#    @steps = -1
#    @turn = [ left, right ]
#  end
#
#  def step(turn : Int32)
#    
#  end
#end

template = [] of String
map = Hash(String, Hash(String, String)).new
File.each_line("input.txt") {|line|
  case line
    when /^([A-Z]+) = [(]([A-Z]+), ([A-Z]+)[)]/
      map[$1] = { "L" => $2, "R" => $3 }

    when /^([LR]+)$/
      template = line.split("")

    when ""

    else
      raise line
  end
}

state = "AAA"
steps = 0
route = [] of String
while state != "ZZZ"
  route += template if route.empty?
  state = map[state][route.shift]
  steps += 1
end
  
puts "#{steps} steps"
