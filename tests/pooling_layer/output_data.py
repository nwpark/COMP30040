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


input = create_input_image(in_channels, in_height, in_width)
result = maxpooling(input, stride)

print_hex_array3d(result, 'output_data.hex', bits)