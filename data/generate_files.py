#!/bin/python

from shutil import copyfile

for i in range(0,5):
  for j in range(0,3):
    f=open("filter_{}_{}.hex".format(i,j), "w+")
    f.write("")
    f.close()

for i in range(0,5):
  for j in range(0,3):
    copyfile("0.hex","filter_{}_{}.hex".format(i,j))