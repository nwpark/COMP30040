from __future__ import print_function
import numpy as np


################################################################################
# Helper methods to convert between hex and decimal
################################################################################

def int2hex(number, bits=16):
  if number < 0:
    hexval = hex((1 << bits) + number)
  else:
    hexval = hex(number)
  return hexval.split('x')[-1].split('L')[0][:]


def int2str(val, bits=16):
  return str(int2hex(val, bits)).zfill(bits / 4)


def hex2int(hexstr, bits=8):
  value = int(hexstr, 16)
  if value & (1 << (bits - 1)):
    value -= 1 << bits
  return value


################################################################################
# Helper methods to print hex arrays
################################################################################

def print_hex_array3d(array, file, bits=8):
  with open(file, 'w') as fh:
    for y in range(array.shape[1]):
      for x in range(array.shape[2]):
        val = ''
        for z in range(array.shape[0]):
          val = val + int2str(array[z, y, x], bits)
        print(val, end=" ", file=fh)
      print(file=fh)


def print_hex_array2d(array, file, bits=8):
  with open(file, 'w') as fh:
    for y in range(array.shape[0]):
      for x in range(array.shape[1]):
        print(int2hex(array[y,x], bits), end=" ", file=fh)
      print(file=fh)


################################################################################
# Helper methods to read and generate test data
################################################################################

def read_filter_weights(out_channels=5, in_channels=3, f_size=5):
  filters = np.empty((out_channels, in_channels, f_size, f_size)).astype(int)
  for out_channel in range(0, out_channels):
    for in_channel in range(0, in_channels):
      with open("../../data/cnn/layer_0/filter_{}_{}.hex".format(out_channel, in_channel)) as fh:
        weights = fh.read().splitlines()
        weights = map(lambda x: hex2int(x), weights)
        weights = np.asarray(weights).reshape((f_size, f_size))
        filters[out_channel,in_channel] = flip_array(weights)
  return filters


def create_input_image(channels=3, height=32, width=64):
  np.random.seed(0)
  return (256 * np.random.random((channels, height, width))).astype(int) - 128


################################################################################
# Helper methods for array manipulation
################################################################################

def flip_array(array):
  return np.flipud(np.fliplr(array))


################################################################################
# Helper methods for CNN operations
################################################################################

def convolve(array, filter, stride):
  filter = flip_array(filter)
  f_size = filter.shape[0]
  out_height = (array.shape[0] - (f_size-1)) / stride
  out_width = (array.shape[1] - (f_size-1)) / stride
  res = np.zeros((out_height, out_width)).astype(int)
  for y in range(0, out_height):
    for x in range(0, out_width):
      res[y, x] = np.sum(filter * array[y*stride:y*stride+f_size, x*stride:x*stride+f_size])
  return res


def convolve3d(array, filters, stride):
  out_channels = filters.shape[0]
  in_channels = filters.shape[1]
  f_size = filters.shape[2]
  out_height = (array.shape[1] - (f_size-1)) / stride
  out_width = (array.shape[2] - (f_size-1)) / stride
  result = np.zeros((out_channels, out_height, out_width)).astype(int)
  for out_channel in range(0, out_channels):
    for in_channel in range(0, in_channels):
      result[out_channel] = result[out_channel] + convolve(array[in_channel], filters[out_channel, in_channel], stride)
  return result


def maxpooling(array, stride):
  out_height = array.shape[1] / stride
  out_width = array.shape[2] / stride
  result = np.zeros((array.shape[0], out_height, out_width)).astype(int)
  for z in range(0, array.shape[0]):
    for y in range(0, out_height):
      for x in range(0, out_width):
        result[z,y,x] = np.max(array[z,y*stride:(y+1)*stride,x*stride:(x+1)*stride])
  return result