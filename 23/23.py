#!/usr/bin/env python3

import networkx as nx
from networkx.classes.function import path_weight

U = (-1, 0)
R = (0, +1)
D = (+1, 0)
L = (0, -1)

allowed = {
  '.': [ U, R, D, L ],
  '^': [ U ],
  '>': [ R ],
  'v': [ D ],
  '<': [ L ],
}

start = None
finish = None
with open("sample.txt") as f:
  grid = [ line.strip() for line in f.readlines() ]
  height = range(0, len(grid))
  width = range(len(grid[0]))
  G1 = nx.DiGraph()
  G2 = nx.DiGraph()

  for row, line in enumerate(grid):
    for col, tile in enumerate(line):

      if tile == '#':
        continue

      if start is None:
        start = (row, col)
      finish = (row, col)

      for move in allowed[tile]:
        move = ( row + move[0], col + move[1] )
        if move[0] in height and move[1] in width and grid[move[0]][move[1]] != '#':
          G1.add_edge((row, col), move)

      for move in allowed['.']:
        move = ( row + move[0], col + move[1] )
        if move[0] in height and move[1] in width and grid[move[0]][move[1]] != '#':
          G2.add_edge((row, col), move, cost = 1)

print(start, finish)
print('part 1', max([len(path) for path in nx.all_simple_edge_paths(G1, start, finish)]))

