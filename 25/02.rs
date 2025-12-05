use std::fs::File;
use std::io::Read;

fn main() {
  let total: u64 = {
    let mut contents = String::new();
    File::open("02.txt").expect("FATAL: Failed to open a.txt.")
      .read_to_string(&mut contents).expect("FATAL: Failed to read contents of a.txt.");
    contents
  }

  .replace('\n', "")

  .split(',')

  .flat_map(|rng| {
    let parts: Vec<&str> = rng.split('-').collect();
    if parts.len() != 2 {
      panic!("FATAL: Invalid range '{}'.", rng);
    }

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
