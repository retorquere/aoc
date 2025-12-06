use regex::Regex;

#[derive(Debug)]
struct Problem {
  op: char, 
  operands: Vec<i64>,
}
impl Problem {
  fn solve(&self) -> i64 {
    match self.op {
      '*' => self.operands.iter().product(),
      '+' => self.operands.iter().sum(),
      _ => panic!("Encountered unhandled operator: {}", self.op),
    }
  }
}

// --------------------------------------------------------

fn main() {
  let input = include_str!("06.txt");

  let lines: Vec<String> = input
    .split('\n')
    .map(|s| s.to_string())
    .filter(|s| !s.is_empty())
    .collect();

  let mut problems: Vec<Problem> = Vec::new();

  for line in &lines {
    let operands: Vec<&str> = line.trim().split_whitespace().collect();
    
    if problems.is_empty() {
      problems = (0..operands.len()).map(|_| {
        Problem { op: '?', operands: Vec::new() } 
      }).collect();
    }

    let lead = operands[0].chars().next().unwrap(); 
    if lead.is_ascii_digit() {
      for (p, operand) in operands.iter().enumerate() {
        problems.get_mut(p).unwrap().operands.push(operand.parse::<i64>().unwrap());
      }
    }
    else {
      for (p, op) in operands.iter().enumerate() {
        problems.get_mut(p).unwrap().op = op.chars().next().unwrap();
      }
    }
  }

  println!("{}", problems.iter().map(|p| p.solve()).sum::<i64>());

  problems = Vec::new();
  let width = lines[0].len(); 
  let transposed: Vec<String> = (0..width) 
    .map(|col| {
      lines.iter()
        .map(|line| line.chars().nth(col).unwrap()) 
        .collect() 
    })
    .collect();

  let keep_op = Regex::new(r"[0-9 ]").unwrap();
  let keep_num = Regex::new(r"[^0-9]").unwrap();
  
  for line in &transposed {
    if line.trim().is_empty() {
      continue;
    }

    let op = keep_op.replace_all(line, "").to_string();

    if !op.is_empty() {
      problems.push(Problem { op: op.chars().next().unwrap(), operands: Vec::new() });
    }

    problems.last_mut().unwrap().operands.push(keep_num.replace_all(line, "").parse::<i64>().unwrap());
  }

  println!("{}", problems.iter().map(|p| p.solve()).sum::<i64>());
}
