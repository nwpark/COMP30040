#!/bin/python

from __future__ import print_function
import numpy as np
import sys
sys.path.insert(0, '..')
from utils import *


# Parameters
in_width = 64
in_height = 32
in_channels = 3
bits = 16


image = create_input_image(in_channels, in_height, in_width)
filters = read_filter_weights()

layer_0 = convolve3d(image, filters, stride=4)
layer_1 = relu(layer_0)
layer_2 = maxpooling(layer_1, stride=2)

# Print result to file
print_hex_array3d(layer_2, 'output_data.hex', bits)