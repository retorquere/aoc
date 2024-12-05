#!/usr/bin/env crystal

CardValue = {
  '2' => "02",
  '3' => "03",
  '4' => "04",
  '5' => "05",
  '6' => "06",
  '7' => "07",
  '8' => "08",
  '9' => "09",
  'T' => "10",
  'J' => "11",
  'Q' => "12",
  'K' => "13",
  'A' => "14",
}

Appraisal = {
  [5]       => [ "7", "5K" ],
  [4,1]     => [ "6", "4K" ],
  [3,2]     => [ "5", "FH" ],
  [3,1,1]   => [ "4", "3K" ],
  [2,2,1]   => [ "3", "2P" ],
  [2,1,1,1] => [ "2", "1P" ],
}

def unjoker(cards : String) : Array(String)
  return [ cards ] if !cards.includes?('J')
  options = cards.chars.uniq.select{|c| c != 'J' }
  options = ['A'] if options.size == 0
  return options.map{|c| unjoker(cards.sub('J', c)) }.flatten
end

def strength(cards : String, part : Int32)
  permutations = part == 1 ? [ cards ] : unjoker(cards)

  scores = permutations.map{|hand|
    score, name = Appraisal[hand.chars.uniq.map{|c| hand.chars.count(c) }.sort.reverse]? || [ "1", "HC" ]
    score += " "

    cards.chars.map{|card| CardValue[card] }.each{|card|
      score += (part == 2 && card == "11" ? "01" : card) + " "
    }
    score += name

    score
  }

  return scores.max
end

class Hand
  property bid
  property strength
  property rank
  property cards

  def initialize(@cards : String, @bid : Int32, @strength = "", @rank = 0)
  end
end

hands = [] of Hand
File.each_line("input.txt") {|line|
  cards, bid = line.split
  hands << Hand.new(cards, bid.to_i)
}

[1, 2].each do |part|
  hands.each do |hand|
    hand.strength = strength(hand.cards, part)
  end
  hands.sort_by{|hand| hand.strength}.each_with_index{|hand, rank| 
    hand.rank = rank + 1
  }
  #hands.each{|hand|
  #  puts "#{hand.cards} #{hand.strength}"
  #}
  puts hands.map{|hand| hand.rank * hand.bid }.sum
end
