#!/usr/bin/env python3

import networkx as nx
import matplotlib.pyplot as plt
from functools import reduce

G = nx.Graph()

start = None
finish = None
with open("input.txt") as f:
  for line in f.readlines():
    c1, to = [p.strip() for p in line.strip().split(':')]
    for c2 in to.split(' '):
      c2 = c2.strip()
      G.add_edge(c1, c2)

print('edges:', nx.edge_connectivity(G))
for edge in nx.minimum_edge_cut(G):
  G.remove_edge(*edge)
components = list(nx.connected_components(G))
print('part 1:', reduce(lambda x, y: x * len(y), [1] + components))

#nx.draw(G)
#plt.show()
