require "option_parser"

input = "5.txt"
OptionParser.parse do |parser|
  parser.on("-t", "optional") { |_| input = "5t.txt" }
end

struct ResourceRange
  property offset

  forward_missing_to @range

  def initialize(@range : Range(Int64, Int64), @offset : Int64)
  end
end

class ResourceMap
  property name
  property needs
  property maps

  @@resources = Hash(String, ResourceMap).new
  def self.resources
    @@resources
  end

  def initialize(@name : String, @needs : String)
    @maps = [] of ResourceRange
    @@resources[name] = self
  end
end

struct Resource
  property name
  property ranges

  def initialize(@name : String, @ranges : Array(Range(Int64, Int64)))
  end
end

resource = Resource.new("seed", [] of Range(Int64, Int64))
reading = nil
File.each_line(input) {|line|
  case line
    when /^seeds: (.+)/
      seeds = $1.split().map{|s| s.to_i64}
      while seeds.size > 0
        from = seeds.shift
        n = seeds.shift
        resource.ranges << (from ... (from + n))
      end

    when /^([a-z]+)-to-([a-z]+) map:$/
      reading = ResourceMap.new($1, $2)

    when /^([0-9]+) ([0-9]+) ([0-9]+)$/
      from = $2.to_i64
      n = $3.to_i64
      offset = $1.to_i64 - from
      reading.as(ResourceMap).maps << ResourceRange.new(from ... (from + n), offset)

    when /^$/

    else
      raise line
  end
}

while resource.name != "location"
  puts "#{resource.name} #{resource.ranges.size}"
  map = ResourceMap.resources[resource.name]
  resource.ranges = resource.ranges.map{|range|
    unmapped = [ range ]
    mapped = [] of Range(Int64, Int64)

    while unmapped.size > 0
      sub = unmapped.pop
      cover = map.maps.find{|cr| cr.covers?(sub.begin) || cr.covers?(sub.end) }
      if cover.nil?
        mapped << range
      else
        unmapped << (sub.begin .. (cover.begin - 1))
        mapped << (([ sub.begin, cover.begin ].max + cover.offset) .. ([ sub.end, cover.end ].min + cover.offset))
        unmapped << ((cover.end + 1) .. sub.end)
      end
      unmapped = unmapped.select{|r| !r.empty? }
    end

    mapped
  }.flatten.sort_by{|r| r.begin }

  compacted = [] of Range(Int64, Int64)
  current_range = resource.ranges.shift

  resource.ranges.each do |range|
    next if range.end <= current_range.end # fully subsumed

    if current_range.end >= range.begin
      current_range = current_range.begin .. range.end
    else
      compacted << current_range
      current_range = range
    end
  end

  compacted << current_range

  resource.ranges = compacted
  resource.name = map.needs
end

def dash(n : Int64) : String
  n.to_s.reverse.split(/(...)/).reverse.select{|n| n != "" }.join("_")
end
resource.ranges = resource.ranges.sort_by{|r| r.begin }
#resource.ranges.each{|r|
#  puts "#{dash(r.begin)} .. #{dash(r.end)}"
#}
puts "min: #{resource.ranges[0].begin}"
