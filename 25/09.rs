fn main() {
  let input = include_str!("09s.txt");

  let mut tiles: Vec<(usize, usize)> = input
    .trim()
    .split('\n')
    .map(|line| {
      let dim = line.split(',').map(|n| n.trim().parse::<usize>().unwrap()).collect::<Vec<usize>>();
      (dim[0], dim[1])
    })
    .collect();
  tiles.sort(); // WTF?!?!?
  println!("{:?}", tiles);
  let n: usize = tiles.len() as usize;

  let mut areas: Vec<usize> = Vec::new();
  for i in 0..n {
    for j in (i + 1)..n {
      let (t1, t2) = (&tiles[i], &tiles[j]);
      areas.push(((t1.0 as i64 - t2.0 as i64 + 1).abs() * (t1.1 as i64 - t2.1 as i64 + 1).abs()) as usize);
    }
  }
  areas.sort();
  // println!("{:?}", rects);
  println!("1: {}", areas.last().unwrap());
}