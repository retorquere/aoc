use std::fs::File;
use std::io::Read;

fn main() {

  let mut turns = String::new();
  File::open("01.txt").expect("FATAL: Failed to open 01.txt.")
    .read_to_string(&mut turns).expect("FATAL: Failed to read contents of a.txt.");

  let mut pos: i32 = 50;
  let mut zeroes: i32 = 0;
  for turn in turns.trim().split('\n') {
    let dir: i32 = if turn.starts_with('L') { -1 } else { 1 };
    let mut steps: i32 = turn[1..].parse().unwrap();

    zeroes += steps / 100;
    steps = dir * (steps % 100);
    if pos != 0 && (pos + steps > 99 || pos + steps <= 0) {
      zeroes += 1;
    }
    pos = (pos + steps + 100) % 100;
  }

  println!("{}", zeroes);
}
