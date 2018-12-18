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
            red = array[0,y,x]
            green = array[1,y,x]
            blue = array[2,y,x]

            value = red + green + blue
            tvalue = 0
            if abs(value) > 7:
                tvalue = 255

            print(int2hex(tvalue), end=" ")#,'//',x,y,'Decimal',value

def convolve2d(givenimage, kernel):
    output = np.zeros((givenimage.shape[0]-2, givenimage.shape[1]-2)).astype(int)
    for x in range(givenimage.shape[1]-2):
        for y in range(givenimage.shape[0]-2):
            output[y,x] = (kernel*givenimage[y:y+3,x:x+3]).sum()
    return output

sobel_kernel = np.array([[-1,0,1],[-2,0,2],[-1,0,1]])

np.random.seed(0)
image = np.zeros((3,480,640)).astype(int)
imagespoofed = np.zeros((image.shape[0],image.shape[1],image.shape[2]+2)).astype(int)

# red
image[0] = (8*np.random.random((480,640))).astype(int)
# green
image[1] = (8*np.random.random((480,640))).astype(int)
# blue
blue = (4*np.random.random((480,640))).astype(int)
image[2] = blue << 1 | blue >> 1

image[:,:240,400:500] = 0
image[:1,241:,400:500] = 7
image[2,241:,400:500] = 7

# red
imagespoofed[0,:image.shape[1],:image.shape[2]] = image[0]
imagespoofed[0,:-1,image.shape[2]:] = image[0,1:,:2]
# green
imagespoofed[1,:image.shape[1],:image.shape[2]] = image[1]
imagespoofed[1,:-1,image.shape[2]:] = image[1,1:,:2]
# blue
imagespoofed[2,:image.shape[1],:image.shape[2]] = image[2]
imagespoofed[2,:-1,image.shape[2]:] = image[2,1:,:2]



output = np.zeros((3,478,640)).astype(int)

output[0] = convolve2d(imagespoofed[0], sobel_kernel)
output[1] = convolve2d(imagespoofed[1], sobel_kernel)
output[2] = convolve2d(imagespoofed[2], sobel_kernel)

output[0,:,1:] = output[0,:,:-1]
output[1,:,1:] = output[1,:,:-1]
output[2,:,1:] = output[2,:,:-1]

# print np.mean(np.absolute(output))
printRGB(output)


# Image.fromarray(output, 'L').show()