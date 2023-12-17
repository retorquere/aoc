#!/usr/bin/env crystal

require "./astar"

alias Coord = Tuple(Int32, Int32)
alias Cell = NamedTuple(id: Int32, row: Int32, col: Int32, cost: Int32)
alias Node = AStar::Node(Cell)
Grid = Hash(Coord, Node).new

File.read("sample.txt").chomp.split("\n").each.with_index do |line, row|
  line.chars.each.with_index do |cost, col|
    Grid[{ row, col }] = Node.new({ id: Grid.size, row: row, col: col, cost: cost.to_i })
  end
end

Grid.values.each do |cell|
  [ {-1, 0}, {0, 1}, {1, 0}, {0, -1} ].each do |move|
    nb = { cell.data[:row] + move[0], cell.data[:col] + move[1] }
    cell.connect(Grid[nb], cell.data[:cost]) if Grid.has_key?(nb)
  end
end

def valid_path(node : Node) : Bool
  path = [] of Node
  path << node
  while (path.size < 3) && (node = node.parent)
    path << node
  end

  return true if path.size < 3
  [ :row, :col ].each do |axis|
    if path.map{|node| node.data[axis]}.uniq.size == 1
      puts "invalid #{path.reverse.map{|cell| [ cell.data[:row], cell.data[:col] ]}}"
      return false
    end
  end
  return true
end

def gml(path)
  puts "graph ["
  puts "  directed 1"
  Grid.values.each do |cell|
    puts "  node ["
    puts "    id #{cell.data[:id]}"
    puts "    label \"#{cell.data[:row]},#{cell.data[:col]} g=#{cell.g} f=#{cell.f}\""
    puts "    graphics ["
    puts "      w 184.0"
    puts "      h 42.0"
    puts "    ]"
    puts "  ]"
  end
  Grid.values.each do |cell|
    cell.neighbor.each do |n, c|
      puts "  edge ["
      puts "    source #{cell.data[:id]}"
      puts "    target #{n.data[:id]}"
      puts "    label \"#{c}\""
      puts "    graphics ["
      puts "      style \"dashed\""
      puts "      targetArrow \"standard\""
      puts "    ]"
      puts "  ]"
    end
  end
  path.each_cons(2) do |pair|
    puts "  edge ["
    puts "    source #{pair[0].data[:id]}"
    puts "    target #{pair[1].data[:id]}"
    puts "    graphics ["
    puts "      width 7"
    puts "      targetArrow \"standard\""
    puts "    ]"
    puts "  ]"
  end
  puts "]"
end
  
puts Grid.keys.max
path = AStar.search(Grid[{0, 0}], Grid[Grid.keys.max]) do |node, goal|
  if valid_path(node)
    (node.data[:row] - goal.data[:row]).abs + (node.data[:col] - goal.data[:col]).abs 
  else
    Float64::INFINITY
  end
end

if path
  dir = { "-1,0" => "^", "0,1" => ">", "1,0" => "v", "0,-1" => "<" }
  last = path[0]
  path[1..].each do |cell|
    puts dir["#{cell.data[:row] - last.data[:row]},#{cell.data[:col] - last.data[:col]}"]
    last = cell
  end
  puts path.map{|cell| cell.data[:cost]}.sum
  gml(path)
else
  puts "No path found."
end
