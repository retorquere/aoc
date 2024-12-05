#!/usr/bin/env python3

import networkx as nx
#from networkx.classes.function import path_weight

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
with open("input.txt") as f:
  grid = [ line.strip() for line in f.readlines() ]
  height = range(0, len(grid))
  width = range(len(grid[0]))
  G1 = nx.DiGraph()
  G2 = nx.DiGraph()

  for row, line in enumerate(grid):
    for col, tile in enumerate(line):
      pos = (row, col)

      if tile == '#':
        continue

      if start is None:
        start = pos
      finish = pos

      for move in allowed[tile]:
        move = ( row + move[0], col + move[1] )
        if move[0] in height and move[1] in width and grid[move[0]][move[1]] != '#':
          G1.add_edge(pos, move, distance = 1)

      for move in allowed['.']:
        move = ( row + move[0], col + move[1] )
        if move[0] in height and move[1] in width and grid[move[0]][move[1]] != '#':
          G2.add_edge(pos, move, distance = 1)

def trim(G):
  before = len(G.nodes)
  while skip := next((node for node in G.nodes if len(list(G.neighbors(node))) == 2), None):
    left, right = G.neighbors(skip)
    distance = sum([G[skip][nb]['distance'] for nb in [ left, right ]])
    G.add_edge(left, right, distance = distance)
    G.add_edge(right, left, distance = distance)
    G.remove_node(skip)
  print('contracted from', before, 'to', len(G.nodes))

def path_distance(G, path):
  return sum(G[left][right]['distance'] for left, right in path)

for part, G in enumerate([G1, G2]):
  trim(G)
  nx.write_gml(G, f"23-{part + 1}.gml")
  print('part', part + 1, max([path_distance(G, path) for path in nx.all_simple_edge_paths(G, start, finish)]))
