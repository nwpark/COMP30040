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


def int2str(val, bits=8):
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
image = (256 * np.random.random((3, 32, 64))).astype(int) - 128
printArray(image, file='input_data.hex')