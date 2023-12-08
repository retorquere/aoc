#!/usr/bin/env crystal

struct Route
  include Iterator(Int32)

  @route : Array(Int32)

  def initialize(route : String)
    @route = route.chars.map{|c| c == 'L' ? 0 : 1 }
    @left = [] of Int32
  end

  def next
    @left = @route.clone if @left.size == 0
    return @left.shift
  end
end

route = Route.new("")
map = Hash(String, Tuple(String, String)).new
File.each_line("input.txt") {|line|
  case line
    when /^([A-Z]+) = [(]([A-Z]+), ([A-Z]+)[)]/
      map[$1] = { $2, $3 }

    when /^([LR]+)$/
      route = Route.new(line)

    when ""

    else
      raise line
  end
}

state = "AAA"
steps = 0
route.each do |turn|
  break if state == "ZZZ"
  state = map[state][turn]
  steps += 1
end
  
puts "#{steps} steps"
