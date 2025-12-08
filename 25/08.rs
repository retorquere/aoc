fn main() {
  let input = include_str!("08.txt");

  let junctions: Vec<Vec<usize>> = input
    .trim()
    .split('\n')
    .map(|line| {
      line.split(',').map(|n| n.trim().parse::<usize>().unwrap()).collect()
    })
    .collect();

  let n: usize = junctions.len() as usize;

  let mut cords: Vec<(usize, usize, usize)> = Vec::new();
  for i in 0..n {
    for j in (i + 1)..n {
      let dist = &junctions[i].iter()
        .zip(&junctions[j])
        .map(|(&c1, &c2)| ((c1 as i64) - (c2 as i64)).pow(2) as usize)
        .sum::<usize>();
      cords.push((i, j, *dist));
    }
  }
  cords.sort_by_key(|e| e.2);

  let mut circuits: Vec<Vec<usize>> = (0..n) 
    .map(|i| vec![i])
    .collect();

  let mut connected = 0;
  for (j1, j2, _) in cords {
    let mut c1 = circuits.iter().position(|c| c.contains(&j1)).unwrap();
    let mut c2 = circuits.iter().position(|c| c.contains(&j2)).unwrap();

    connected += 1;
    if c1 != c2 {
      if c1 > c2 {
        std::mem::swap(&mut c1, &mut c2);
      }

      let joined = circuits.remove(c2);
      circuits[c1].extend(joined);

      if connected == 1000 {
        let mut sizes = circuits.iter().map(|c| c.len()).collect::<Vec<usize>>();
        sizes.sort();

        println!("1: {}", sizes
          .iter()
          .rev()
          .take(3)
          .product::<usize>());
      }

      if circuits.len() == 1 {
        println!("2: {}", junctions[j1][0] * junctions[j2][0]);
        break;
      }
    }
  }
}