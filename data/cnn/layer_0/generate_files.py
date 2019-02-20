#!/bin/python

from __future__ import print_function
from shutil import copyfile
import numpy as np

def int2hex(number, bits=8):
  if number < 0:
    hexval = hex((1 << bits) + number)
  else:
    hexval = hex(number)
  return hexval.split('x')[-1].split('L')[0][:]


def int2str(val, bits=8):
  return str(int2hex(val)).zfill(bits/4)


def printArray(array, file):
  with open(file, 'w') as fh:
    for y in reversed(range(0,filter.shape[0])):
      for x in reversed(range(0,filter.shape[1])):
        print(int2str(array[y,x]), file=fh)


np.random.seed(1)
filter = (64 * np.random.random((5,5))).astype(int) - 32

printArray(filter, "0.hex")

for i in range(0,5):
  for j in range(0,3):
    copyfile("0.hex","filter_{}_{}.hex".format(i,j))