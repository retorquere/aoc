use std::cmp::{min, max};

#[derive(Debug, Clone, Copy)]
struct Tile {
  row: i64,
  col: i64,
}

struct Segment {
  top: i64,
  bottom: i64,
  left: i64,
  right: i64,
}

fn main() {
  let input = include_str!("09.txt");
  let tiles: Vec<Tile> = input
    .lines()
    .filter(|s| !s.trim().is_empty())
    .map(|line| {
      let parts: Vec<&str> = line.split(',').collect();
      let col = parts[0].trim().parse::<i64>().unwrap();
      let row = parts[1].trim().parse::<i64>().unwrap();
      
      Tile { row, col }
    })
    .collect();
  
  let perimeter: Vec<Segment> = tiles
    .iter()
    .enumerate()
    .map(|(index, &t1)| {
      let t2 = tiles.get(index + 1).unwrap_or(&tiles[0]);

      let top = min(t1.row, t2.row);
      let bottom = max(t1.row, t2.row);
      let left = min(t1.col, t2.col);
      let right = max(t1.col, t2.col);
    
      Segment { top, bottom, left, right }
    }).collect();

  let mut largest_rect: i64 = 0; 
  let mut largest_enclosed: i64 = 0; 
  for i in 0..tiles.len() {
    let t1 = tiles[i];

    for j in (i + 1)..tiles.len() {
      let t2 = tiles[j];

      let top = min(t1.row, t2.row);
      let bottom = max(t1.row, t2.row);
      let left = min(t1.col, t2.col);
      let right = max(t1.col, t2.col);

      let area = ((right - left) as i64 + 1) * ((bottom - top) as i64 + 1);

      if area > largest_rect {
        largest_rect = area;
      }

      if area > largest_enclosed && !(perimeter.iter().any(|segment| { segment.top < bottom && segment.bottom > top && segment.left < right && segment.right > left })) {
        largest_enclosed = area;
      }
    }
  }

  println!("part1 {}", largest_rect);
  println!("part2 {}", largest_enclosed);
}
