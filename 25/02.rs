fn main() {
  let total: u64 = include_str!("02.txt")
    .replace('\n', "")
    .split(',')
    .flat_map(|rng| {
      let parts: Vec<&str> = rng.split('-').collect();
      let start = parts[0].parse::<u64>().unwrap();
      let end = parts[1].parse::<u64>().unwrap();
      start..=end
    })
    .map(|n| {
      let ns = n.to_string();
      let ln = ns.len();

      for p in 1..=(ln / 2) {
        if ln % p == 0 {
          if ns == ns.get(0..p).unwrap().repeat(ln / p) {
            return n;
          }
        }
      }

      0
    })
    .sum(); 

  println!("{}", total);
}
