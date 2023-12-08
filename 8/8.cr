#!/usr/bin/env crystal

struct Route
  property id
  property path
  property step
  property cycle : Int64

  def initialize(@id : Int64, @path : String)
    @step = @path[0..0]
    @cycle = (@id + 1) % @path.size
  end
end

struct Node
  @@node = Hash(String, Node).new
  def self.node
    @@node
  end
  def self.nodes
    @@node.keys
  end

  @@routes = [] of Route
  def self.route
    @@routes
  end
  def self.route=(v : String)
    d = v + v
    @@routes = (0...v.size).map{|i| Route.new(i, d[i ... (i + v.size)]) }
  end

  def initialize(@name : String, left : String, right : String)
    @turn = { "L" => left, "R" => right }
    @@node[@name] = self
  end

  def step(step : String)
    return @turn[step]
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
  starts = Node.nodes.select{|node| node.ends_with?(start)}

  paths = starts.map{|state|
    route = Node.route[0]
    steps = 0
    while !state.ends_with?(finish)
      state = Node.node[state].step(route.step)
      route = Node.route[route.cycle]
      steps += 1
    end

    steps
  }
  
  puts "part #{start.size > 1 ? 1 : 2}"
  puts paths.reduce(1_i64) { |acc, n| acc.lcm(n) } 
}
