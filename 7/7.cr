#!/usr/bin/env crystal

CardValue = {
  '2' => 2,
  '3' => 3,
  '4' => 4,
  '5' => 5,
  '6' => 6,
  '7' => 7,
  '8' => 8,
  '9' => 9,
  'T' => 10,
  'J' => 11,
  'Q' => 12,
  'K' => 13,
  'A' => 14,
}

Appraisal = {
  [5]       => [ "7", "5K" ],
  [4,1]     => [ "6", "4K" ],
  [3,2]     => [ "5", "FH" ],
  [3,1,1]   => [ "4", "3K" ],
  [2,2,1]   => [ "3", "2P" ],
  [2,1,1,1] => [ "2", "1P" ],
}

def strength(cards : String)
  score, name = Appraisal[cards.chars.uniq.map{|c| cards.chars.count(c) }.sort.reverse]? || [ "1", "HC" ]

  cards.chars.map{|card| CardValue[card] }.each{|card|
    score += "C" + card.to_s.rjust(2, '0')
  }
  score += name

  return score
end

class Hand
  property bid
  property strength
  property rank
  property cards

  def initialize(@cards : String, @bid : Int32, @strength : String, @rank = 0)
  end
end

hands = [] of Hand
File.each_line("input.txt") {|line|
  cards, bid = line.split
  hands << Hand.new(cards, bid.to_i, strength(cards))
}

hands = hands.sort_by{|hand| hand.strength}
hands.sort_by{|hand| hand.strength}.each_with_index{|hand, rank| 
  hand.rank = rank + 1
}
#hands.each{|hand|
#  puts "#{hand.cards} #{hand.strength}"
#}
puts hands.map{|hand| hand.rank * hand.bid }.sum
