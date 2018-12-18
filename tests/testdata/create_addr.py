#!/bin/python

from __future__ import print_function

utils = __import__('utils')

for addr in range(160, 76640):
    print(utils.int2hex(addr), end=" ")