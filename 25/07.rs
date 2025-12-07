use std::collections::{HashSet, HashMap};

fn main() {
  let input = include_str!("07.txt");
  let lines: Vec<&str> = input.lines().collect();
  let start = lines[0].find('S').unwrap() as i64;
  let manifold = 0i64 .. lines[0].len() as i64;

  let splitters: Vec<i64> = lines
    .iter()
    .flat_map(|row| 
      row
        .chars()
        .enumerate()
        .filter(|&(_, char)| char == '^')
        .map(|(index, _)| index as i64)
    )
    .collect();

  let mut splits = 0;
  let mut beams1: HashSet<i64> = HashSet::new();
  beams1.insert(start);
  for &splitter in &splitters {
    if beams1.contains(&splitter) {
      splits += 1;
      beams1.remove(&splitter);

      for &way in [-1i64, 1i64].iter() {
        if manifold.contains(&(splitter + way)) { // deref a calculation... this is fucking nuts. Why no pass by value?!?!
          beams1.insert(splitter + way);
        }
      }
    }
  }
  println!("1: {}", splits);

  let mut beams2: HashMap<i64, i64> = HashMap::new();
  beams2.insert(start, 1);
  for &splitter in &splitters {
    if let Some(&count) = beams2.get(&splitter) {
      beams2.remove(&splitter);
      
      for &way in [-1i64, 1i64].iter() {
        if manifold.contains(&(splitter + way)) {
          *beams2.entry(splitter + way).or_insert(0) += count;
        }
      }
    }
  }
  println!("2: {}", beams2.values().sum::<i64>());
}
