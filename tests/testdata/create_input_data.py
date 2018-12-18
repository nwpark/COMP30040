#!/bin/python

from __future__ import print_function
import numpy as np
from PIL import Image

def int2hex(number):
    bits = 16
    if number < 0:
        hexval = hex((1 << bits) + number)
    else:
        hexval = hex(number)
    return hexval.split('x')[-1].split('L')[0][-2:]

def print2d(array):
    for y in range(array.shape[0]):
        for x in range(array.shape[1]):
            value = array[y,x]
            print(int2hex(value), end=" ")#,'//',x,y,'Decimal',value

def printRGB(array):
    for y in range(array.shape[1]):
        for x in range(array.shape[2]):
            red = array[0,y,x] << 5
            green = array[1,y,x] << 2
            blue = array[2,y,x]

            value = red | green | blue

            print(int2hex(value), end=" ")#,'//',x,y,'Decimal',value


np.random.seed(0)
image = np.zeros((3,480,640)).astype(int)

# red
image[0] = (8*np.random.random((480,640))).astype(int)
# green
image[1] = (8*np.random.random((480,640))).astype(int)
# BLUE
image[2] = (4*np.random.random((480,640))).astype(int)


image[:,:240,400:500] = 0
image[:1,241:,400:500] = 7
image[2,241:,400:500] = 3


printRGB(image)


# image = Image.open('/home/mbyx4np3/COMP27112/ex3/sickle.jpg')