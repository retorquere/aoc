fn shift(jolt: String, bank: String, length: usize) -> (String, String) {
  let reserve: usize = (length - jolt.len()) - 1;
  let (d, p) = bank[..bank.len()-reserve]
    .chars()
    .enumerate()
    .max_by_key(|&(i, c)| (c, -(i as i64)))
    .map(|(i, c)| (c.to_digit(10).unwrap(), i))
    .unwrap();

  // println!("jolt={}, bank={}, reserve={} => {} @ {}", jolt, bank, reserve, d, p);


  ( format!("{}{}", jolt, d), bank[p+1..].to_string() )
}

fn main() {
  println!("{}", std::fs::read_to_string("03.txt").unwrap().trim().split('\n').map(|b| {
    let mut bank = b.to_string();
    if bank.is_empty() { return 0; }

    // println!("scanning {}", b);
    let mut jolt = String::from("");
    while jolt.len() < 12 {
      (jolt, bank) = shift(jolt, bank, 12);
    }
    // println!("  {}: {}", b, jolt);

    jolt.parse().unwrap()
  }).sum::<i64>());
}
