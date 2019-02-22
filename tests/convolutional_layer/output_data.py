#!/bin/python

from __future__ import print_function
import numpy as np
import sys
sys.path.insert(0, '..')
from utils import *


# Parameters
stride = 4
in_width = 64
in_height = 32
in_channels = 3
bits = 16

# Read filter weights from file
filters = read_filter_weights()
# Generate input image
input = create_input_image(in_channels, in_height, in_width)
# Convolve filter with input
result = convolve3d(input, filters, stride)

# Print result to file
print_hex_array3d(result, 'output_data.hex', bits)