#!/usr/bin/env ruby

class Entry
  property src_begin
  property src_end
  property dst_begin

  def initialize(@src_begin : Int64, @dst_begin : Int64, len : Int64)
    @src_end = @src_begin + len
  end
end

def map_entry(entry, src)
  entry.dst_begin + (src - entry.src_begin)
end

def apply_map(src_range : Range(Int64, Int64), entries : Array(Entry))
  mapped = [] of Range(Int64, Int64)
  matched = false
  entries.each do |entry|
    next if entry.src_begin >= src_range.end || src_range.begin >= entry.src_end
    matched = true
    mapped << (map_entry(entry, [src_range.begin, entry.src_begin].max) ... map_entry(entry, [src_range.end, entry.src_end].min))
    mapped.concat(apply_map((src_range.begin...entry.src_begin), entries)) if src_range.begin < entry.src_begin
    mapped.concat(apply_map((entry.src_end...src_range.end), entries)) if entry.src_end < src_range.end
  end
  mapped << src_range unless matched
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
