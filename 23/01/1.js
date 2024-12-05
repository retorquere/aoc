const fs = require('fs')
const input = fs.readFileSync('1.txt', 'utf-8')

let total = 0
for (let line of input.split('\n')) {
  if (!line) continue

  line = line
    .replace(/one/g, 'o1ne')
    .replace(/two/g, 't2wo')
    .replace(/three/g, 't3hree')
    .replace(/four/g, 'f4our')
    .replace(/five/g, 'f5ive')
    .replace(/six/g, 's6ix')
    .replace(/seven/g, 's7even')
    .replace(/eight/g, 'e8ight')
    .replace(/nine/g, 'n9ine')
  line = line.replace(/[^0-9]/g, '')
  console.log(line)
  total += parseInt(line[0] + line.slice(-1))
}
console.log(total)

