#!/usr/bin/env crystal

sum = 0
File.new("sample.txt").each_line{|line|
  map, counts = line.split

  dots = "([.?]+?)"
  re = Regex.new("^([.?]*?)" + counts.split(",").map{|d| "([#?]{#{d}})#{dots}" }.join("").chomp(dots) + "([.?]*)$")
  total = counts.split(",").map{|c| c.to_i}.sum

  todo = [ map ]
  while i = todo.index{|m| m.includes?("?") }
    t = todo.delete_at(i)
    [".", "#"].each{|c|
      c = t.sub("?", c)
      todo << c if c.gsub(".", "").size >= total
    }
  end

  sum += todo.select{|m| re.match(m)}.size
}
puts sum

