from __future__ import print_function
import numpy as np


def int2hex(number, bits=16):
  if number < 0:
    hexval = hex((1 << bits) + number)
  else:
    hexval = hex(number)
  return hexval.split('x')[-1].split('L')[0][:]
  # return hexval.split('x')[-1].split('L')[0][-2:]
  # return hexval.split('x')[-1]


def int2str(val, bits=16):
  return str(int2hex(val, bits)).zfill(bits / 4)


def hex2int(hexstr, bits=8):
  value = int(hexstr, 16)
  if value & (1 << (bits - 1)):
    value -= 1 << bits
  return value


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


def flip_array(array):
  return np.flipud(np.fliplr(array))


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