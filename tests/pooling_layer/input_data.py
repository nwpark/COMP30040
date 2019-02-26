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
bits = 8


input = create_input_image(in_channels, in_height, in_width)

print_hex_array3d(input, 'input_data.hex', bits)