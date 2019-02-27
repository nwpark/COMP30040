#!/bin/python

from __future__ import print_function
import numpy as np
import sys
sys.path.insert(0, '..')
from utils import *


# Parameters
width = 64
height = 32
channels = 3
bits = 8


image = create_input_image(channels, height, width)

print_hex_array3d(image, 'input_data.hex', bits)