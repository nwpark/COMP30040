#!/bin/python

from __future__ import print_function
import numpy as np


def int2hex(number):
  bits = 5
  if number < 0:
    hexval = hex((1 << bits) + number)
  else:
    hexval = hex(number)
  return hexval.split('x')[-1].split('L')[0][:]


def printArray(array):
  for y in range(array.shape[0]):
    for x in range(array.shape[1]):
      print(int2hex(array[y,x]), end=" ")
    print()


np.random.seed(1)

image = (32 * np.random.random((32, 64))).astype(int)

printArray(image)
