#!/bin/python

import matplotlib.pyplot as plt

luts_da = [388, 352, 328, 268, 244, 208, 120, 96, 52]
luts_parallel = [464, 420, 380, 300, 260, 184, 140, 64, 24]
zerod = [0, 0.111, 0.222, 0.333, 0.444, 0.556, 0.667, 0.778, 0.889]

plt.title('Resource Utilization')
plt.plot(zerod, luts_da, label='Distributed Arithmetic')
plt.plot(zerod, luts_parallel, label='Constant Coefficient Multipliers')
plt.ylabel('Number of 4-input LUTs')
plt.xlabel('Percentage of Weights Pruned')
plt.legend()
plt.show()