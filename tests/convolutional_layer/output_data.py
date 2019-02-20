#!/bin/python

from __future__ import print_function
import numpy as np
import sys
sys.path.insert(0, '..')
from utils import *


f_size = 5
stride = 4
in_width = 64
in_height = 32
in_channels = 3
out_width = (in_width - (f_size-1)) / stride
out_height = (in_height - (f_size-1)) / stride
out_channels = 5
bits = 16


def convolve(array, filter):
  filter = flip_array(filter)
  res = np.zeros((out_height, out_width)).astype(int)
  for y in range(0, out_height):
    for x in range(0, out_width):
      res[y, x] = np.sum(filter * array[y*stride:y*stride+f_size, x*stride:x*stride+f_size])
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


# Read filter weights from files
filters = read_filter_weights()

# Generate random input image
np.random.seed(0)
input = (256 * np.random.random((in_channels, in_height, in_width))).astype(int) - 128

# Initialize array to hold result
result = np.zeros((out_channels, out_height, out_width)).astype(int)

# Generate filter with random weights
np.random.seed(1)
filter = (64 * np.random.random((f_size, f_size))).astype(int) - 32

# Perform convolution on all input and output channels
for out_channel in range(0, result.shape[0]):
  for in_channel in range(0, input.shape[0]):
    result[out_channel] = result[out_channel] + convolve(input[in_channel], filters[out_channel, in_channel])

# Write result to file
print_hex_array3d(result, 'output_data.hex', bits)