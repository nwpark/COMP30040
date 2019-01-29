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


def maxpooling(array):
  # reshape each row into groups of 2 (horizontally adjacent)
  a=array.reshape(32,32,2)
  # take maximum from each group of 2
  a=np.amax(a, axis=2)
  # reshape each row into groups of 2 rows (to get vertically adjacent pixels)
  a=a.reshape(16,2,32)
  # element wise maximum for each group of 2 rows
  a=np.maximum(a[:,0],a[:,1])
  return a


np.random.seed(0)
channel_0 = (32 * np.random.random((32, 64))).astype(int)

np.random.seed(1)
channel_1 = (32 * np.random.random((32, 64))).astype(int)

np.random.seed(2)
channel_2 = (32 * np.random.random((32, 64))).astype(int)


c0_out = maxpooling(channel_0)
c1_out = maxpooling(channel_1)
c2_out = maxpooling(channel_2)

data = (c0_out << 16) + (c1_out << 8) + c2_out
printArray(data, file='output_data.hex')