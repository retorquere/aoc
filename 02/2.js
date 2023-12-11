const fs = require('fs')
const input = fs.readFileSync('2.txt', 'utf-8')

const min = { red: 12, green: 13, blue: 14 }

let sum = 0
for (const line of input.split('\n')) {
  if (!line) continue
  const [, id ] = line.match(/^Game ([0-9]+)/)

  const min = { red: 0, blue: 0, green: 0 }
  const game = line.split(';').map(round => {
    const res = { red: 0, green: 0, blue: 0 }
    round.replace(/([0-9]+)\s+(red|green|blue)/g, (m, n, c) => {
      res[c] += parseInt(n)
      min[c] = Math.max(min[c], res[c])
    })
    return res
  })

  const pow = Object.values(min).reduce((p, n) => p * n, 1)
  sum += pow

  // if (game.find(round => Object.entries(min).find(([c, v]) => v < round[c]))) continue
  // sum += parseInt(id)
}
console.log(sum)
