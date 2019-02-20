#!/bin/python

from __future__ import print_function
import numpy as np
import sys
sys.path.insert(0, '..')
from utils import *


np.random.seed(0)
channel_0 = (256 * np.random.random((32, 64))).astype(int)

np.random.seed(1)
channel_1 = (256 * np.random.random((32, 64))).astype(int)

np.random.seed(2)
channel_2 = (256 * np.random.random((32, 64))).astype(int)

data = (channel_0 << 16) + (channel_1 << 8) + channel_2
print_hex_array2d(data, 'input_data.hex', 8)