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

def concatenate(val, count, bits):
  return str(val).zfill(bits/4) * count

def printArray(array, file):
  with open(file, 'w') as fh:
    for y in range(array.shape[0]):
      for x in range(array.shape[1]):
        result = concatenate(int2hex(array[y,x]), 5, 16)
        print(result, end=" ", file=fh)
      print(file=fh)


np.random.seed(0)
channel_0 = (32 * np.random.random((32, 64))).astype(int)

np.random.seed(1)
channel_1 = (32 * np.random.random((32, 64))).astype(int)

np.random.seed(2)
channel_2 = (32 * np.random.random((32, 64))).astype(int)

filter = np.ones((5,5)).astype(int)

c0_out = sp.convolve2d(channel_0, filter, mode='valid', boundary='wrap')
c1_out = sp.convolve2d(channel_1, filter, mode='valid', boundary='wrap')
c2_out = sp.convolve2d(channel_2, filter, mode='valid', boundary='wrap')

data = c0_out + c1_out + c2_out

printArray(data, 'output_data.hex')