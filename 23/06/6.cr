#!/usr/bin/env crystal

require "big"

time = 0
distance = 0
File.each_line("input.txt") {|line|
  case line
    when /^Time: (.+)/
      time = BigInt.new($1.gsub(" ", "").to_i64)

    when /^Distance: (.+)/
      distance = BigInt.new($1.gsub(" ", "").to_i64)

    when /^$/

    else
      raise line
  end
}

puts "#{time} -> #{distance}"

options = 0
(1...time).each{|hold|
  d = hold * (time - hold)
  if d > distance
    options += 1
  end
}
puts options
