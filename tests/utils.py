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
