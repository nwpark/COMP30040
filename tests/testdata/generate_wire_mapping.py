#!/bin/python3

bits_per_pixel = 8
pixels_per_word = 4 # number of pixels
kernel_size = 3

varname = '.pixel{}(pixel_reg_{}_{}[{}:{}]),'

rowname = '.pixel{}(pixel_row_{}[{}:{}]),'


def print_pixel_addresses(offset):
  pixelcount = 0
  for row in range(kernel_size):
    # b
    for b in range(pixels_per_word - (kernel_size - 1) + offset, pixels_per_word):
      print(varname.format(pixelcount, row, 'b', (b+1)*bits_per_pixel-1, b*bits_per_pixel))
      pixelcount+=1
    # a
    for a in range(max(0, offset-kernel_size+1), offset+1):
      print(varname.format(pixelcount, row, 'a', (a+1)*bits_per_pixel-1, a*bits_per_pixel))
      pixelcount+=1

def print_row_addresses(offset):
  pixelcount = 0
  for row in range(kernel_size):
    for col in range(kernel_size):
      print(rowname.format(pixelcount, row, 63-((col + offset)*bits_per_pixel), 63-((col + offset + 1)*bits_per_pixel - 1)))
      pixelcount += 1

for offset in range(pixels_per_word):
  # print_pixel_addresses(offset)
  print_row_addresses(offset)
  print()
