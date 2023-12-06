require "option_parser"

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
File.each_line("input.txt") {|line|
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
  }.flatten#.sort_by{|r| r.begin }

  #compacted = [] of Range(Int64, Int64)
  #current = resource.ranges.shift

  #resource.ranges.each do |range|
  #  next if range.end <= current.end # fully subsumed

  #  if current.end >= range.begin
  #    current = current.begin .. range.end
  #  else
  #    compacted << current
  #    current = range
  #  end
  #end

  #compacted << current
  #resource.ranges = compacted

  resource.name = map.needs
end

sol = resource.ranges.sort_by{|r| r.begin }.first

puts "min: #{sol.begin}"

ResourceMap.resources["humidity"].maps.each{|r|
  r = (r.begin + r.offset) .. (r.end + r.offset)
  puts r.begin if r.covers?(sol.begin) && r.covers?(sol.end)
}
