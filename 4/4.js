const fs = require('fs')
let input = fs.readFileSync('4.txt', 'utf-8').split('\n').filter(line => line)

const cards = input.map(card => card.replace(/.*:/, '').split('|').map(list => list.trim().split(/\s+/)))
  .map(([winning, hand], card) => ({
    card: card + 1,
    copies: 1,
    winning,
    hand,
    score: hand.filter(n => winning.includes(n)).length,
  }))
console.log(cards.reduce((acc, card) => acc + (card.score ? Math.pow(2, card.score - 1) : 0), 0))

const range = (p, n) => [...Array(n).keys()].map(k => k + p)

for (const card of cards) {
  for (const c of range(0, card.copies)) {
    for (const i of range(card.card, card.score)) {
      cards[i].copies += 1
    }
  }
}
console.log(cards.reduce((acc, card) => acc + card.copies, 0))
