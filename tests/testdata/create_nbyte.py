#!/bin/python

from __future__ import print_function
import numpy as np

def print2d(array):
    for y in range(array.shape[0]):
        for x in range(array.shape[1]):
            print(array[y,x], end=" ")

nbyte = np.zeros((478,160)).astype(int)
nbyte[:,0] = 1
nbyte[:,-1] = 8

print2d(nbyte)