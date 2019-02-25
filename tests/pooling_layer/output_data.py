#!/bin/python

from __future__ import print_function
import numpy as np
import sys
sys.path.insert(0, '..')
from utils import *


# Parameters
stride = 2
in_width = 64
in_height = 32
in_channels = 3
bits = 8


np.random.seed(0)
input = (32 * np.random.random((in_channels, in_height, in_width))).astype(int)

result = maxpooling(input, stride)

print_hex_array3d(result, 'output_data.hex', bits)