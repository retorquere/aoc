struct ResourceRange
  property mapped
  property offset

  forward_missing_to @range

  def initialize(@range : Range(Int64, Int64), @offset : Int64, @mapped = false)
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

  def add(map : ResourceRange)
    @maps << map
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
File.each_line("5.txt") {|line|
  case line
    when /^seeds: (.+)/
      seeds = $1.split().map{|s| s.to_i64}
      while seeds.size > 0
        from = seeds.shift
        n = seeds.shift
        resource.ranges << (from ... (from + n))
      end

    when /^([a-z]+)-to-([a-z]+) map:/
      reading = ResourceMap.new($1, $2)

    when /^([0-9]+) ([0-9]+) ([0-9]+)/
      from = $2.to_i64
      n = $3.to_i64
      offset = $1.to_i64 - from
      reading.as(ResourceMap).add(ResourceRange.new(from ... (from + n), offset))

    when /^$/

    else
      raise line
  end
}

while resource.name != "location"
  map = ResourceMap.resources[resource.name]
  resource.ranges = resource.ranges.map{|range|
    unmapped = [ range ]
    mapped = [] of Range(Int64, Int64)

    while unmapped.size > 0
      sub = unmapped.pop
      cover = map.maps.find{|cr| cr.covers?(sub.begin) || cr.covers?(sub.end) }
      if cover.nil?
        mapped << range
      elsif cover.covers?(sub.begin) && cover.covers?(sub.end)
        mapped << ((sub.begin + cover.offset) ... (sub.end + cover.offset))
      else
        unmapped << (sub.begin .. (cover.begin - 1))
        mapped << (([ sub.begin, cover.begin ].max + cover.offset) .. ([ sub.end, cover.end ].min + cover.offset))
        unmapped << ((cover.end + 1) .. sub.end)
      end
      unmapped = unmapped.select{|r| !r.empty? }
    end

    mapped
  }.flatten

  resource.name = map.needs
end

resource.ranges = resource.ranges.sort_by{|r| r.begin }

puts resource.ranges[0].begin
