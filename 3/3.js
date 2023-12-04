/*
const fs = require('fs')
let input = fs.readFileSync('3.txt', 'utf-8').split('\n').filter(line => line)

let ll = input[0].length
console.log('ll', ll)

const grid = [ [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1] ]
function adjacent(r, c) {
  return [ [-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1] ]
    .filter(([dr, dc]) => c + dc >= 0 && c + dc < ll && r + dr >= 0 && r + dr < input.length)
    .map(([dr, dc]) => [ r + dr, c + dc ])
}

let sum = 0
const parts = {}
input.forEach((line, r) => {
  line.replace(/([0-9]+)/g, (m, n, c) => {
    let part
    for (const cc of [...Array(n.length).keys()].map(i => i + c)) {
      part = adjacent(r, cc).filter(([pr, pc]) => !input[pr][pc].match(/[.0-9]/)).map(([pr, pc]) => ({ r: pr, c: pc, p: input[pr][pc], adj: [] }))[0]
      if (part) break
    }

    if (!part || part.p != '*') return
    const p = `${part.r}x${part.c}`
    parts[p] = parts[p] || part
    parts[p].adj.push(parseInt(n))
    parts[p].ratio = parts[p].adj.reduce((acc, p) => acc * p)

    // sum += parseInt(n)
  })
})
// console.log(sum)
console.log(Object.values(parts).filter(p => p.adj.length == 2).map(p => p.ratio).reduce((acc, n) => acc + n))
*/

const input = fs.readFileSync('3.txt', 'utf-8').trim()
const ll = input.indexOf('\n') + 2
console.log('ll', ll)
const padline = Array(ll).fill('.').join('')
const padded = padline + '\n' + input.replace(/\n/g, '.\n.') + '\n' + padline

const grid = [ - (ll + 1), -ll, - (ll - 1), -1, 1, ll - 1, ll, ll + 1 ]

const range = (p, n) => [...Array(n).keys()].map(k => k + p)

padded.replace(/([0-9]+)/g, (m, n, c) => {
  const part = range(c, n.length).find(i => grid.find(offset => input[i + offset] === '*'))
  const part = range(c, n.length).map(i => grid.find(offset => input[i + offset] === '*'))
  for (c of range(c, n.length)) {

  }

