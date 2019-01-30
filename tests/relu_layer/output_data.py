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
channel_0 = (32 * np.random.random((32, 64))).astype(int)

np.random.seed(1)
channel_1 = (32 * np.random.random((32, 64))).astype(int)

np.random.seed(2)
channel_2 = (32 * np.random.random((32, 64))).astype(int)


c0_out = np.maximum(channel_0,0)
c1_out = np.maximum(channel_1,0)
c2_out = np.maximum(channel_2,0)

data = (c0_out << 16) + (c1_out << 8) + c2_out
printArray(data, file='output_data.hex')