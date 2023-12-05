struct ResourceMap
  property me
  property needs
  property n

  def initialize(@me : Int64, @needs : Int64, @n : Int64)
  end
end

class Resource
  @@resources = Hash(String, Resource).new
  def self.resources
    @@resources
  end

  def initialize(name : String, needs : String)
    @name = name
    @needs = needs
    @ranges = [] of ResourceMap
    @@resources[name] = self
  end

  def add(range : ResourceMap)
    @ranges << range
  end

  def resolve(resource : Int64)
    range = @ranges.find{|r| resource >= r.me && resource <= r.me + r.n }
    needs = range ? range.needs + (resource - range.me) : resource
    return @needs == "location" ? needs : @@resources[@needs].resolve(needs)
  end
end

seeds = [] of Int64
reading = nil
File.each_line("5.txt") {|line|
  case line
    when /^seeds: (.+)/
      seeds = $1.split().map{|s| s.to_i64}

    when /^([a-z]+)-to-([a-z]+) map:/
      reading = Resource.new($1, $2)

    when /^([0-9]+) ([0-9]+) ([0-9]+)/
      reading.as(Resource).add(ResourceMap.new($2.to_i64, $1.to_i64, $3.to_i64))

    when /^$/

    else
      raise line
  end
}

minimal = -1
while seeds.size > 0
  remaining = (seeds.size / 2).to_i
  from = seeds.shift()
  n = from + seeds.shift()
  puts "#{remaining} batches remaining, locating #{n} seeds"
  (from...(from + n)).each{|seed|
    location = Resource.resources["seed"].resolve(seed)
    minimal = location if minimal == -1 || minimal > location
  }
end
puts "location: #{minimal}"
