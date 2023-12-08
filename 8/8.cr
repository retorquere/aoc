#!/usr/bin/env crystal

struct Node
  @@node = Hash(String, Node).new
  def self.node
    @@node
  end
  def self.nodes
    @@node.keys
  end

  @@route = ""
  def self.route
    @@route
  end
  def self.route=(v)
    @@route = v
  end

  def initialize(@name : String, left : String, right : String)
    @turn = { "L" => left, "R" => right }
    @@node[@name] = self
  end

  def step(route : String)
    return @turn[route[0..0]]
  end
end

File.each_line("input.txt") {|line|
  case line
    when /^([A-Z]+) = [(]([A-Z]+), ([A-Z]+)[)]/
      Node.new($1, $2, $3)

    when /^([LR]+)$/
      Node.route = line

    when ""

    else
      raise line
  end
}

[["AAA", "ZZZ"], ["A", "Z"]].each{|config|
  start, finish = config
  state = Node.nodes.select{|node| node.ends_with?(start)}
  steps = 0
  route = ""
  while state.select{|node| !node.ends_with?("ZZZ")}.size > 0
    route += Node.route if route.empty?
    step = route[0..0]
    route = route[1..]
    state = state.map{|s| Node.node[s].step(step) }
    steps += 1
  end
  puts "part #{start.size > 1 ? 1 : 2 }: #{steps} steps"
}
