#!/bin/python

from __future__ import print_function
import numpy as np
import sys
sys.path.insert(0, '..')
from utils import *


width = 64
height = 32
channels = 3
bits = 8


np.random.seed(0)
image = (256 * np.random.random((channels, height, width))).astype(int) - 128
print_hex_array3d(image, 'input_data.hex', bits)