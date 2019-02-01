#!/bin/python

from __future__ import print_function
import numpy as np
import scipy.signal as sp


def int2hex(number):
  bits = 16
  if number < 0:
    hexval = hex((1 << bits) + number)
  else:
    hexval = hex(number)
  return hexval.split('x')[-1].split('L')[0][:]


def int2str(val, bits=16):
  return str(int2hex(val)).zfill(bits/4)


def printArray(array, file):
  with open(file, 'w') as fh:
    for y in range(array.shape[1]):
      for x in range(array.shape[2]):
        val = ''
        for z in range(array.shape[0]):
          val = val + int2str(array[z,y,x])
        print(val, end=" ", file=fh)
      print(file=fh)


np.random.seed(0)
input = (256 * np.random.random((3, 32, 64))).astype(int) - 128

result = np.zeros((5, 28, 60)).astype(int)

np.random.seed(1)
filter = (64 * np.random.random((5,5))).astype(int) - 32

for out_channel in range(0, result.shape[0]):
  for in_channel in range(0, input.shape[0]):
    result[out_channel] = result[out_channel] + sp.convolve2d(input[in_channel], filter, mode='valid', boundary='wrap')


printArray(result, 'output_data.hex')