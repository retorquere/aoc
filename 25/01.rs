fn main() {
  let turns = include_str!("01.txt");

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
