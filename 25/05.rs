use std::ops::Range;
use std::collections::HashSet;
use itertools::Itertools;
use std::cmp::max;
use std::time::Instant;

#[derive(Hash, Eq, Copy, PartialEq, Debug, Clone)]
enum Category {
  Fresh,
  All,
}

fn main() {
  let mut started = Instant::now();
  // let mut input = String::new();
  // File::open("05.txt").expect("FATAL: Failed to open input.")
  // .read_to_string(&mut input).expect("FATAL: Failed to read input.");
  let input = include_str!("05.txt");

  let mut is_fresh: Vec<Range<i64>> = Vec::new();
  let mut ingredients: HashSet<i64> = HashSet::new();
  let mut cat = Category::Fresh;

  for line in input.trim().split('\n') {
    if line == "" {
      cat = Category::All;
    }
    else if cat == Category::Fresh {
      let ends: Vec<&str> = line.split('-').collect();
      let start: i64 = ends.get(0).unwrap().parse().unwrap();
      let end: i64 = ends.last().unwrap().parse().unwrap();
      is_fresh.push(start .. end + 1);
    }
    else {
      ingredients.insert(line.parse().unwrap());
    }
  }
  println!("load took {:?}", started.elapsed());

  started = Instant::now();
  let mut n_fresh: i64 = 0;
  for ingredient in &ingredients {
    if is_fresh.iter().any(|range| range.contains(&ingredient)) {
      n_fresh += 1;
    }
  }
  println!("{} ingredients are fresh ({:?})", n_fresh, started.elapsed());

  started = Instant::now();

  let n_fresh: i64 = is_fresh
    .into_iter()
    .sorted_by_key(|range| range.start)
    .fold(Vec::new(), |mut acc: Vec<Range<i64>>, range| {
      if let Some(last_range) = acc.last_mut() {
        // if last_range.contains(&start) // this does not work?!
        if last_range.start <= range.start && range.start < last_range.end {
          // let extended = last_range.start .. max(last_range.end, range.end);
          // acc.pop();
          // acc.push(extended);
          last_range.end = max(last_range.end, range.end);
        }
        else {
          acc.push(range)
        }
      }
      else {
        acc.push(range)
      }

      acc
    })
    .into_iter()
    .fold(0i64, |acc, range| { acc + (range.end - range.start) });

  println!("{} ingredients could be fresh ({:?})", n_fresh, started.elapsed());
}
