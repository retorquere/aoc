#!/usr/bin/env crystal

alias Row = Hash(Symbol, UInt128)

class CPlatform
  @width = 0
  @rows : Array(Row)

  property width
  property rows

  def initialize
    @rows = File.read("input.txt").strip.split("\n").map{|row|
      @width = row.size
      {
        :round => row.gsub(".", "0").gsub("#", "0").gsub("O", "1").to_u128(2),
        :cube => row.gsub(".", "0").gsub("#", "1").gsub("O", "0").to_u128(2)
      }
    }
  end

  def n
    (1 ... @rows.size).each do |times|
      (1 ... @rows.size).each do |row|
        up = @rows[row - 1]
        capacity = ~(up[:round] | up[:cube])
        move = capacity & @rows[row][:round]
        @rows[row - 1][:round] += move
        @rows[row][:round] -= move
      end
    end
  end

  def s
    (1 ... @rows.size).each do |times|
      (@rows.size - 1).downto(1) do
        down = @rows[row + 1]
        capacity = ~(down[:round] | down[:cube])
        move = capacity & @rows[row][:round]
        @rows[row + 1][:round] += move
        @rows[row][:round] -= move
      end
    end
  end

  def chars(row : UInt128)
    return row.to_s(2).rjust(@width, '0').chars
  end

  def weight
    @rows.each_with_index.map{|row, i|
      row[:round].to_s(2).count("1") * (@rows.size - i)
    }.sum
  end

  def show
    puts "-" * @width
    @rows.each do |row|
      puts self.chars(row[:round]).zip(self.chars(row[:cube])).map{|rc| {"00" => ".", "10" => "O", "01" => "#"}[rc.join("")] }.join("")
    end
  end
end
Platform = CPlatform.new

Platform.show
Platform.n
Platform.show
puts Platform.weight
