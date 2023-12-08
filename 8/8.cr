#!/usr/bin/env crystal

template = ""
map = Hash(String, Hash(String, String)).new

struct Node
  @@map = Hash(String, Tuple(String, String)).new

  @paths : Array(String)

  property name

  def initialize(@name : String, left : String, right : String)
    @paths = [] of String
    @turn = { "L" => left, "R" => right }
  end

  def walk(route : String) : String
    return "" if @name == "ZZZ"

    route += template if route.empty?

    @paths.each{|p|
      return p if route + (template * p.size).start_with?(p)
    }

    @paths << route[0] + @@map[@turn[route[0..0]]].walk(route[1..])
    return @paths[-1]
  end
end

File.each_line("input.txt") {|line|
  case line
    when /^([A-Z]+) = [(]([A-Z]+), ([A-Z]+)[)]/
      map[$1] = { "L" => $2, "R" => $3 }

    when /^([LR]+)$/
      template = line

    when ""

    else
      raise line
  end
}

state = "AAA"
steps = 0
route = ""
while state != "ZZZ"
  route += template if route.empty?
  puts map[state]
  state = map[state][route[0..0]]
  route = route[1..]
  steps += 1
end
  
puts "#{steps} steps"
