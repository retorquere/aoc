#!/usr/bin/env crystal

class CPlatform
  @width = 0

  @round : Array(UInt128)
  @cube : Array(UInt128)

  property width
  property round
  property cube

  def initialize
    @round = [] of UInt128
    @cube = [] of UInt128
    File.read("input.txt").strip.split("\n").map{|row|
      @width = row.size
      @round << row.gsub(".", "0").gsub("#", "0").gsub("O", "1").to_u128(2)
      @cube << row.gsub(".", "0").gsub("#", "1").gsub("O", "0").to_u128(2)
    }
  end

  def n
    (1 ... @round.size).each do |times|
      (1 ... @round.size).each do |row|
        up = row - 1
        capacity = ~(@round[up] | @cube[up])
        move = capacity & @round[row]
        @round[up] += move
        @round[row] -= move
      end
    end
  end

  def rot(rows : Array(UInt128)) : Array(UInt128)
    rows.map{|row| self.chars(row) }.transpose.map{|row| row.reverse.join("").to_u128(2) }
  end

  def rotate
    @round = self.rot(@round)
    @cube = self.rot(@cube)
  end

  def cycle
    4.times do
      self.n
      self.rotate
    end
  end

  def run(n = 1_u128)
    self.initialize
    rounds = Hash(Array(UInt128), Int32).new
    effectively = 0
    n.times do |round|
      key = @round + @cube
      if rounds.has_key?(key)
        rampup = rounds[key] + 1
        loop = round - rounds[key]
        effectively = rampup + (n - rampup) % loop
        break
      end

      self.cycle
      rounds[key] = round
    end

    self.initialize
    effectively.times do
      self.cycle
    end
  end

  def chars(row : UInt128)
    return row.to_s(2).rjust(@width, '0').chars
  end

  def weight
    @round.each_with_index.map{|row, i|
      row.to_s(2).count("1") * (@round.size - i)
    }.sum
  end

  def show
    puts "-" * @width
    rows = @round.zip(@cube).map{|round, cube| { round: round, cube: cube }}
    rows.each do |row|
      puts self.chars(row[:round]).zip(self.chars(row[:cube])).map{|rc| {"00" => ".", "10" => "O", "01" => "#"}[rc.join("")] }.join("")
    end
  end
end
Platform = CPlatform.new

#Platform.show
Platform.n
#Platform.show
puts Platform.weight

Platform.run(1000000000)
puts Platform.weight
