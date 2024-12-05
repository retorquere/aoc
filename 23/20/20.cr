#!/usr/bin/env crystal

class Graph
  class_property targets = Hash(String, Array(String)).new
  class_property conjunction = Hash(String, Hash(String, Int32)).new
  class_property flipflop = Hash(String, Int32).new
  class_property activator = ""
  class_property counters = Hash(String, Int32).new
  class_property pulses = { 1 => 0, 0 => 0 }
  class_property smashed = 0
  class_property moduletype = Hash(String, Char).new
end

File.read("input.txt").chomp.split("\n").each do |line|
  m = line.match(/^([%&]?)([a-z]+) -> (.*)/)
  raise line unless m
  _, kind, name, targets = m
  Graph.targets[name] = targets.split(", ")
  Graph.activator = name if Graph.targets[name].includes?("rx")

  Graph.moduletype[name] = { "&" => 'C', "%" => 'F', "" => 'B' }[kind]
  Graph.conjunction[name] = Hash(String, Int32).new if kind == "&"
  Graph.flipflop[name] = 0 if kind == "%"
end

Graph.targets.each do |source, targets|
  targets.each do |target|
    Graph.conjunction[target][source] = 0 if Graph.conjunction.has_key?(target)
  end
end

def smash()
  Graph.smashed += 1

  Graph.pulses[0] += 1 # button press
  Graph.pulses[0] += Graph.targets["broadcaster"].size # the pulses sent by the button press

  ops = Graph.targets["broadcaster"].map{ |target| { "broadcaster", target, 0 } }
  pulsout = 0
  until ops.empty?
    src, target, pulse = ops.shift()

    next if target == "rx"

    case Graph.moduletype[target]
      when 'C'
        Graph.conjunction[target][src] = pulse
        pulsout = Graph.conjunction[target].values.sum == Graph.conjunction[target].size ? 0 : 1

      when 'F'
        next if pulse == 1
        Graph.flipflop[target] = 1 - Graph.flipflop[target]
        pulsout = Graph.flipflop[target]

      else
        raise "?!"
    end

    Graph.pulses[pulsout] += Graph.targets[target].size

    ops += Graph.targets[target].map{|tgt| { target, tgt, pulsout } }

    Graph.counters.each do |counter|
    end

    Graph.conjunction[Graph.activator].each do |name, state|
      next if state == 0
      next if Graph.counters.has_key?(name)
      Graph.counters[name] = Graph.smashed
    end
  end
end


1000.times do
  smash
end
puts "part 1: #{Graph.pulses.values.product(1_i64)}"

while Graph.conjunction[Graph.activator].size != Graph.counters.size
  smash
end

puts "part 2: #{Graph.counters.values.reduce(1_i64){ |acc, c| acc.lcm(c) }}"
