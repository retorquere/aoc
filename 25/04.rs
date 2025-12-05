use std::fs;
use petgraph::graphmap::UnGraphMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub struct Coord {
  row: i32,
  col: i32,
}

fn main() {
  let mut map: UnGraphMap<Coord, i32> = UnGraphMap::new();

  for (r, rolls) in fs::read_to_string("04.txt").unwrap().trim().split('\n').enumerate() {
    for (c, cell) in rolls.chars().enumerate() {
      if cell == '@' {
        map.add_node(Coord{ row: r as i32, col: c as i32});
      }
    }
  }

  for v in map.nodes().collect::<Vec<_>>() {
    for dr in -1..=1 {
      for dc in -1..=1 {
        if dr != 0 || dc != 0 {
          let w = Coord{ row: v.row + dr, col: v.col + dc };
          if map.contains_node(w) {
            map.add_edge(v, w, 1i32);
          }
        }
      }
    }
  }

  let mut removed: i32 = 0;
  loop {
    let mut reachable: Vec<Coord> = map.nodes()
      .filter(|&node| map.neighbors(node).count() < 4)
      .collect();
    reachable.sort_by_key(|coord| (coord.row, coord.col));

    if reachable.is_empty() {
      break;
    }

    // println!("before {}, removing {}", map.nodes().len(), reachable.len());
    removed += reachable.len() as i32;
    for node in reachable {
      map.remove_node(node);
    }
    // println!("  after {}", map.nodes().len());
    // break;
  }

  println!("\ntotal: {}", removed);
}
