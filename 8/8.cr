#!/usr/bin/env crystal

route = [] of Int32
map = Hash(String, Tuple(String, String)).new
File.each_line("input.txt") {|line|
  case line
    when /^([A-Z]+) = [(]([A-Z]+), ([A-Z]+)[)]/
      map[$1] = { $2, $3 }

    when /^([LR]+)$/
      route = line.chars.map{|c| {'L' => 0, 'R' => 1}[c] }

    when ""

    else
      raise line
  end
}

state = "AAA"
steps = 0
r = route.clone
while state != "ZZZ"
  r = route.clone() if r.size == 0
  state = map[state][r.shift]
  steps += 1
end
puts steps
