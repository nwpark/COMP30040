#!/bin/python

from __future__ import print_function
import numpy as np


def int2hex(number):
  bits = 16
  if number < 0:
    hexval = hex((1 << bits) + number)
  else:
    hexval = hex(number)
  return hexval.split('x')[-1].split('L')[0][:]


def printArray(array, file):
  with open(file, 'w') as fh:
    for y in range(array.shape[0]):
      for x in range(array.shape[1]):
        print(int2hex(array[y,x]), end=" ", file=fh)
      print(file=fh)


np.random.seed(0)
channel_0 = (256 * np.random.random((32, 64))).astype(int)

np.random.seed(1)
channel_1 = (256 * np.random.random((32, 64))).astype(int)

np.random.seed(2)
channel_2 = (256 * np.random.random((32, 64))).astype(int)

channel_0[channel_0 > 127] = 0
channel_1[channel_1 > 127] = 0
channel_2[channel_2 > 127] = 0

data = (channel_0 << 16) + (channel_1 << 8) + channel_2
printArray(data, file='output_data.hex')