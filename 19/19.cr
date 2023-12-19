#!/usr/bin/env crystal

alias Part = Hash(Char, Range(Int32, Int32))

class Filter
  property attr
  property range
  property state

  def initialize(@attr : Char, @range : Range(Int32, Int32), @state : String)
    @pass = (@attr == ' ')
  end

  def prune(other : Filter)
    return if other.attr != self.attr

    if other.range.covers?(@range.begin) && other.range.covers?(@range.end)
      raise "#{@attr}#{@range} fully covered by #{other.range}"
    elsif other.range.covers?(@range.begin)
      @range = (other.range.end + 1) .. @range.end
    elsif other.range.covers?(@range.end)
      @range = @range.begin .. (other.range.begin - 1)
    end
  end

  def match(part : Part) : String
    if @pass
      @state
    elsif @range.covers?(part[@attr].begin) && @range.covers?(part[@attr].end)
      @state
    else
      ""
    end
  end

  def split(part : Part) : Tuple(Part, Array(Part))
    if @pass
      return { part, [] of Part }
    else
      partrange = part[@attr]
      return {
        part.merge({ @attr => [ partrange.begin, @range.begin ].max .. [ partrange.end, @range.end ].min }),
        [ (partrange.begin ... @range.begin), ((@range.end + 1) .. partrange.end) ].select{|rng| rng.size > 0 }.map{ |rng| part.merge({ @attr => rng }) }
      }
    end
  end
end

class Rule
  property filters

  def initialize(@filters : Array(Filter))
    @filters.each_with_index do |filter, i|
      next if i == 0
      @filters[ 0 ... i ].each do |pred|
        filter.prune(pred)
      end
    end
  end

  def apply(part : Part) : String
    @filters.map{|filter| filter.match(part) }.find{|state| state != "" } || "R"
  end
end

Rules = Hash(String, Rule).new
Parts = [] of Part

File.read("input.txt").chomp.split("\n").each do |line|
  case line

  when /^([a-z]+)[{]([^}]+)/
    Rules[$1] = Rule.new($2.split(",").map{|op|
      case op
        when /^([xmas])([<>])([0-9]+):([a-zAR]+)$/
          n = $3.to_i
          Filter.new($1[0], ($2 == "<") ? (1 .. (n - 1)) : ((n + 1) .. 4000), $4)

        else
          Filter.new(' ', 0 .. 0, op)
      end
    })

  when /^$/

  when /^[{]([^}]+)/
    Parts << $1.split(",").reduce(Part.new){|part, assignment|
      attr, n = assignment.split("=")
      part.merge({ attr[0] => n.to_i .. n.to_i })
    }

  else
    raise "not a stanza: #{line}"
    raise line
  end
end

puts "part 1: #{Parts.select{|part|
  state = "in"
  until state.match(/^[AR]$/)
    state = Rules[state].apply(part)
  end
  state == "A"
}.map{|part| part.values.map{|r| r.begin}.sum }.sum}"

ops = [
  { "in", 0, { 'x' => 1 .. 4000, 'm' => 1 .. 4000, 'a' => 1 .. 4000, 's' => 1 .. 4000 } }
]
sum = 0_i64
until ops.empty?
  state, fidx, part = ops.pop
  if state == "A"
    sum += part.values.map{|rng| rng.size }.product(1_i64)
  elsif state == "R"
    # pass
  else
    filter = Rules[state].filters[fidx]
    match, excluded = filter.split(part)
    ops << { filter.state, 0, match }
    excluded.each do |part|
      ops << { state, fidx + 1, part }
    end
  end
end

puts "part2 sample expect: 167409079868000"
puts "part2: < 124722078563800"
puts sum
