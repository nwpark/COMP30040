#!/bin/python

from __future__ import print_function
import numpy as np
import scipy.signal as sp


f_size = 5
stride = 4
in_width = 64
in_height = 32
in_channels = 3
out_width = (in_width - (f_size-1)) / stride
out_height = (in_height - (f_size-1)) / stride
out_channels = 5


def int2hex(number):
  bits = 16
  if number < 0:
    hexval = hex((1 << bits) + number)
  else:
    hexval = hex(number)
  return hexval.split('x')[-1].split('L')[0][:]


def int2str(val, bits=16):
  return str(int2hex(val)).zfill(bits/4)


def hex2int(hexstr,bits=8):
  value = int(hexstr,16)
  if value & (1 << (bits-1)):
    value -= 1 << bits
  return value


def printArray(array, file):
  with open(file, 'w') as fh:
    for y in range(array.shape[1]):
      for x in range(array.shape[2]):
        val = ''
        for z in range(array.shape[0]):
          val = val + int2str(array[z,y,x])
        print(val, end=" ", file=fh)
      print(file=fh)


def flip_array(array):
  return np.flipud(np.fliplr(array))


def convolve(array, filter):
  filter2 = np.flipud(np.fliplr(filter))
  res = np.zeros((out_height, out_width)).astype(int)
  for y in range(0, out_height):
    for x in range(0, out_width):
      res[y, x] = np.sum(filter2 * array[y*stride:y*stride+f_size, x*stride:x*stride+f_size])
  return res


def read_filter_weights():
  filters = np.empty((out_channels, in_channels, f_size, f_size)).astype(int)
  for out_channel in range(0, out_channels):
    for in_channel in range(0, in_channels):
      with open("../../data/alexnet/layer_0/filter_{}_{}.hex".format(out_channel, in_channel)) as fh:
        weights = fh.read().splitlines()
        weights = map(lambda x: hex2int(x), weights)
        weights = np.asarray(weights).reshape((f_size, f_size))
        filters[out_channel,in_channel] = flip_array(weights)
  return filters


filters = read_filter_weights()

np.random.seed(0)
input = (256 * np.random.random((in_channels, in_height, in_width))).astype(int) - 128

result = np.zeros((out_channels, out_height, out_width)).astype(int)

np.random.seed(1)
filter = (64 * np.random.random((f_size, f_size))).astype(int) - 32

for out_channel in range(0, result.shape[0]):
  for in_channel in range(0, input.shape[0]):
    result[out_channel] = result[out_channel] + convolve(input[in_channel], filters[out_channel, in_channel])


printArray(result, 'output_data.hex')