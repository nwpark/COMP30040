#!/bin/python

from __future__ import print_function
import numpy as np
import scipy.signal as sp


f_size = 5
stride = 1
in_width = 64
in_height = 32
out_width = (in_width - (f_size-1)) / stride
out_height = (in_height - (f_size-1)) / stride

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


def convolve(array, filter):
  filter2 = np.flipud(np.fliplr(filter))
  res = np.zeros((out_height, out_width)).astype(int)
  for y in range(0, out_height):
    for x in range(0, out_width):
      res[y, x] = np.sum(filter2 * array[y*stride:y*stride+f_size, x*stride:x*stride+f_size])
  return res


np.random.seed(0)
input = (256 * np.random.random((3, in_height, in_width))).astype(int) - 128

result = np.zeros((5, out_height, out_width)).astype(int)

np.random.seed(1)
filter = (64 * np.random.random((f_size, f_size))).astype(int) - 32

for out_channel in range(0, result.shape[0]):
  for in_channel in range(0, input.shape[0]):
    # result[out_channel] = result[out_channel] + sp.convolve2d(input[in_channel], filter, mode='valid', boundary='wrap')
    result[out_channel] = result[out_channel] + convolve(input[in_channel], filter)


printArray(result, 'output_data.hex')