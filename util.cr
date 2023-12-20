require "json"

struct Range(B, E)
  def covers?(other : Range(B, E))
    return false if !self.covers?(other.begin)

    my_end = self.excludes_end? ? self.end - 1 : self.end
    other_end = other.excludes_end? ? other.end - 1 : other.end
    return (self.begin .. my_end).covers?(other_end)
  end

  def overlaps?(other : Range(B, E))
    return true if other.covers?(self)

    return true if self.covers?(other.begin)

    my_end = self.excludes_end? ? self.end - 1 : self.end
    other_end = other.excludes_end? ? other.end - 1 : other.end
    return (self.begin .. my_end).covers?(other_end)
  end

  def *(other : Range(B, E)) : Range(B, E)
    return [self.begin, other.begin].max .. [self.end, other.end].min
  end

  def -(other : Range(B, E)) : Array(Range(B, E))
    return [] of self if other.covers?(self)
    return [ self ] if !other.overlaps?(self)

    my_end = self.excludes_end? ? self.end - 1 : self.end
    other_end = other.excludes_end? ? other.end - 1 : other.end
    return [ (self.begin .. (other.begin - 1)), ((other_end + 1) .. my_end) ].select{|r| !r.empty? }
  end
end

class GML
  property nodes = {} of Int32 => String
  property labels = {} of Int32 => String
  property edges = Set(Tuple(Int32, Int32)).new

  def node(name : String, label : String = "")
    raise "duplicate #{name}" if @nodes.values.includes?(name)
    id = @nodes.size
    @nodes[id] = name
    @labels[id] = label.size == 0 ? name : label
  end

  def edge(from : String, to : String)
    from = @nodes.key_for(from)
    to = @nodes.key_for(to)
    @edges.add({ from, to })
  end

  def write(path : String)
    File.open(path, "w") do |f|
      f.puts "graph ["
      f.puts "  directed 1"

      @nodes.each do |id, label|
        f.puts "  node ["
        f.puts "    id #{id}"
        f.puts "    label #{@labels[id].to_json}"
        f.puts "    graphics ["
        f.puts "      w #{@labels[id].size * 7}.0"
        f.puts "      h 30.0"
        f.puts "    ]"
        f.puts "  ]"
      end

      @edges.each do |source, target|
        f.puts "  edge ["
        f.puts "    source #{source}"
        f.puts "    target #{target}"
        f.puts "    graphics ["
        f.puts "      targetArrow \"standard\""
        f.puts "    ]"
        f.puts "  ]"
      end

      f.puts "]"
    end
    end
  end
