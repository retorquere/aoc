#!/usr/bin/env crystal

def find_center(rows : Array(Array(Char)), allow_smudges : Bool, evade : Int32, mode : String) : Int32
  rows = rows.map{|row| row.join("").to_i(2) }
  pairs = rows.each_cons(2).to_a
  centers = pairs.each_with_index.select{|pair, i|
    (pair[0] == pair[1]) || (allow_smudges && (pair[0] ^ pair[1]).to_s(2).count('1') == 1)
  }.map{|pair, i| i}.to_a.select{|i|
    i != evade
  }
  
  return -1 if centers.size == 0

  centers = centers.select{|center|
    smudges = 0
    sides = [center, rows.size - (center + 2)].min
    match = true
    (0..sides).each{|offset|
      left = rows[center - (offset)]
      right = rows[center + offset + 1]
      if left == right
        # pass
      elsif allow_smudges && (left ^ right).to_s(2).count('1') == 1
        smudges += 1
        if smudges > 1
          match = false
          break
        end
      else
        match = false
        break
      end
    }
    match
  }
  
  case centers.size
  when 0
    return -1
  when 1
    return centers[0]
  else
    raise "too many centers"
  end
end

fields = File.read("input.txt").strip.split("\n\n").map{|field|
  field.split("\n").map{|row|
    row.gsub(".", "0").gsub('#', "1").chars
  }
}

part1 = 0
part2 = 0
fields.each_with_index{|rows, i|
  if (row = find_center(rows, false, -1, "rows")) >= 0
    part1 += (row + 1) * 100
    col = -1
  elsif (col = find_center(rows.transpose, false, -1, "cols")) >= 0
    part1 += col + 1
  end

  if (center = find_center(rows, true, row, "rows")) >= 0
    part2 += (center + 1) * 100
  elsif (center = find_center(rows.transpose, true, col, "cols")) >= 0
    part2 += center + 1
  end
}
puts "part1: #{part1}"
puts "part2: #{part2}"
