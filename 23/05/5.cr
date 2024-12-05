#!/usr/bin/env ruby

class Entry
  property src
  property dst

  def initialize(src : Int64, dst : Int64, len : Int64)
    @src = src ... (src + len)
    @dst = dst ... (dst + len)
  end
end

def convert(entry : Entry, src : Int64)
  entry.dst.begin + (src - entry.src.begin)
end

def apply_map(src : Range(Int64, Int64), entries : Array(Entry))
  mapped = [] of Range(Int64, Int64)
  matched = false
  entries.each do |entry|
    next if entry.src.begin >= src.end || src.begin >= entry.src.end
    matched = true
    mapped << (convert(entry, [src.begin, entry.src.begin].max) ... convert(entry, [src.end, entry.src.end].min))
    mapped.concat(apply_map((src.begin...entry.src.begin), entries)) if src.begin < entry.src.begin
    mapped.concat(apply_map((entry.src.end...src.end), entries)) if entry.src.end < src.end
  end
  mapped << src unless matched
  mapped
end

Stanzas = File.read("input.txt").chomp.split("\n\n")
Seeds = Stanzas.shift.sub("seeds: ", "").split.map{|i| i.to_i64}

Maps = Stanzas.map{|map|
  map.split("\n")[1..].map{|line|
    dst, src, len = line.split.map{|i| i.to_i64}
    Entry.new(src, dst, len)
  }
}

def solve(seeds)
  Maps.each{|map|
    seeds = seeds.map{|rng| apply_map(rng, map) }.flatten.uniq
  }
  seeds.min_by{|rng| rng.begin}.begin
end

puts "part 2: #{solve(Seeds.map{|s| s .. s })}"
puts "part 2: #{solve(Seeds.each_slice(2).to_a.map{|r| r[0] ... r.sum })}"
