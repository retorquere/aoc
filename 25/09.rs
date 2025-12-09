fn main() {
  let input = include_str!("09s.txt");

  let mut tiles: Vec<Vec<usize>> = input
    .trim()
    .split('\n')
    .map(|line| {
      line.split(',').map(|n| n.trim().parse::<usize>().unwrap()).collect()
    })
    .collect();

  let n: usize = tiles.len() as usize;

  let mut rects: Vec<(usize, usize, usize)> = Vec::new();
  for i in 0..n {
    for j in (i + 1)..n {
      let size = &tiles[i].iter()
        .zip(&tiles[j])
        .map(|(&c1, &c2)| ((c1 as i64) - (c2 as i64) + 1i64).abs() as usize)
        .product::<usize>();
      rects.push((i, j, *size));
    }
  }
  rects.sort_by_key(|e| e.2);
  // println!("{:?}", rects);
  println!("1: {}", rects.last().unwrap().2);
}