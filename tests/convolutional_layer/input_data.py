#!/bin/python

from __future__ import print_function
import numpy as np


def int2hex(number):
  bits = 8
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

printArray(channel_0, file='channel_0.hex')
printArray(channel_1, file='channel_1.hex')
printArray(channel_2, file='channel_2.hex')
