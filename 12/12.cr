#!/usr/bin/env crystal

Cache = Hash(String, Int64).new
def fits(unmatched : String, sizes : Array(Int64))
  key = "#{unmatched} " + sizes.map{|n| n.to_s}.join(" ")
  Cache[key] = uncached_fits(unmatched, sizes) if !Cache.has_key?(key)
  return Cache[key]
end

def uncached_fits(unmatched : String, sizes : Array(Int64)) : Int64
  unmatched = unmatched.lstrip(".")

  return sizes.empty? ? 1_i64 : 0_i64 if unmatched == ""

  # valid junk at the end
  return unmatched.includes?("#") ? 0_i64 : 1_i64 if sizes.empty?

  if unmatched[0] == '#' # unmatched starts with '#' so remove the first spring
    if unmatched.size < sizes[0] || unmatched[0...(sizes[0])].includes?(".")
      # too small || first stretch cannot be a spring
      return 0_i64
    elsif unmatched.size == sizes[0]
      return sizes.size == 1 ? 1_i64 : 0_i64 # last spring
    elsif unmatched[sizes[0]] == '#'
      return 0_i64 # spring too long
    else
      return fits(unmatched[(sizes[0] + 1)..], sizes[1..]) # on to the next spring
    end
  end

  # try with leading '?' changed to '#', or omit the leading '.'
  return fits("#" + unmatched[1..], sizes) + fits(unmatched[1..], sizes)
end

part1 = 0_i64
part2 = 0_i64
File.new("sample.txt").each_line do |line|
  map, sizes = line.split
  sizes = sizes.split(",").map{|n| n.to_i64 }
  part1 += fits(map, sizes)
  part2 += fits(([map] * 5).join('?'), sizes * 5)
end
puts part1
puts part2
