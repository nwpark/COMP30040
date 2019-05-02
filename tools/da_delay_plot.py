#!/bin/python

import matplotlib.pyplot as plt

delay_da = [10.800, 10.565, 10.806, 9.179, 9.273, 9.179, 6.072, 6.134, 3.003]
delay_parallel = [20.689, 18.647, 15.616, 14.083, 11.052, 9.103, 6.072, 4.305, 0.890]
zerod = [0, 0.111, 0.222, 0.333, 0.444, 0.556, 0.667, 0.778, 0.889]

plt.title('Path Delay')
plt.plot(zerod, delay_da, label='Distributed Arithmetic')
plt.plot(zerod, delay_parallel, label='Constant Coefficient Multipliers')
plt.ylabel('Maximum Combinatorial Path Delay (nanoseconds)')
plt.xlabel('Percentage of Weights Pruned')
plt.legend()
plt.show()