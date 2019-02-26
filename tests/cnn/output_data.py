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


image = create_input_image(in_channels, in_height, in_width)
filters = read_filter_weights()

layer_0 = convolve3d(image, filters, stride)
# layer_1 = maxpooling(layer_0, stride)

# Print result to file
print_hex_array3d(layer_0, 'output_data.hex', bits)