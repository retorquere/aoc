use std::collections::{HashMap};

fn main() {
  let grid: Vec<Vec<char>> = include_str!("07.txt")
    .trim()
    .lines()
    .map(|row| row.chars().collect() )
    .collect();

  let mut beams: HashMap<usize, usize> = HashMap::from([ ( grid[0].iter().position(|&c| c == 'S').unwrap() as usize, 1usize ) ]);
  let mut splits: usize = 0;
  for line in &grid[1..] {
    let mut next_beams: HashMap<usize, usize> = HashMap::new();
    for (col, count) in beams.into_iter() {
      if line[col] == '^' {
        splits += 1;
        *next_beams.entry(col - 1).or_insert(0) += count;
        *next_beams.entry(col + 1).or_insert(0) += count;
      }
      else {
        *next_beams.entry(col).or_insert(0) += count;
      }
    }
    beams = next_beams;
  }
  println!("part1: {}, part2: {}", splits, beams.values().sum::<usize>())
}
