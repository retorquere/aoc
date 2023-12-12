#!/usr/bin/env crystal

sum = 0
File.new("input.txt").each_line{|line|
  map, counts = line.split

  dots = "[.?]+?"
  maybedots = "[.?]*?"
  re = Regex.new "^" + maybedots + counts.split(",").map{|d| "[#?]{#{d}}#{dots}" }.join("").rstrip(dots) + maybedots + "$"
  
  candidates = [ map ]
  while i = candidates.index{|m| m.includes?("?") }
    t = candidates.delete_at(i)
    [".", "#"].each{|c|
      c = t.sub("?", c)
      candidates << c if re.match(c)
    }
  end

  puts line
  puts candidates

  sum += candidates.size
}
puts sum

