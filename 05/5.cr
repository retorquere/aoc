#!/usr/bin/env crystal

module G  
  class_property seeds = [] of Int64
end

alias Map = NamedTuple(makes: Range(Int64, Int64), takes: Range(Int64, Int64))
alias Ranges = Array(Range(Int64, Int64))

class ResourceConverter
  @@for = Hash(String, ResourceConverter).new
  def self.for
    @@for
  end

  property takes
  property makes
  property maps

  def initialize(@makes : String, @takes : String, @maps = [] of Map)
    @@for[@takes] = self
  end

  def overlap?(r1 : Range(Int64, Int64), r2 : Range(Int64, Int64))
    r1.covers?(r2.begin) || r2.covers?(r1.begin)
  end
  
  def convert(ranges : Ranges) : Ranges
    unmapped = ranges.clone
    mapped = [] of Range(Int64, Int64)
    while !unmapped.empty?
      range = unmapped.pop
      cover = @maps.find({ makes: range, takes: range }){|map| self.overlap?(range, map[:takes]) }

      left = range.begin ... cover[:takes].begin
      overlap = [ range.begin, cover[:takes].begin ].max .. [ range.end, cover[:takes].end ].min
      right = (cover[:takes].end + 1) .. range.end

      unmapped << left if !left.empty?
      unmapped << right if !right.empty?

      offset = cover[:makes].begin - cover[:takes].begin
      mapped << ((overlap.begin + offset) .. (overlap.end + offset))
    end
    return mapped
  end
end

File.each_line("input.txt") {|line|
  case line
  when /seeds: (.+)/
    G.seeds = $1.split.map{|n| n.to_i64}

  when /^$/

  when /^([a-z]+)-to-([a-z]+) map:/
    ResourceConverter.new($2, $1)

  when /^([0-9]+) ([0-9]+) ([0-9]+)/
    makes = $1.to_i64
    takes = $2.to_i64
    len = $3.to_i64
    ResourceConverter.for.last_value.maps << { makes: makes...(makes + len), takes: takes...(takes + len) }
  end
}

def solve(ranges)
  resource = "seed"
  while resource != "location"
    converter = ResourceConverter.for[resource]
    ranges = converter.convert(ranges)
    resource = converter.makes
  end
  ranges = ranges.sort_by{|range| range.begin}
  puts ranges[0].begin
end

solve(G.seeds.map{|n| n..n })
solve(G.seeds.each_slice(2).to_a.map{|sl| sl[0] ... (sl.sum) })
