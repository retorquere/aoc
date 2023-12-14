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
    File.read("sample.txt").strip.split("\n").map{|row|
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

Platform.show
Platform.n
Platform.show
puts Platform.weight
