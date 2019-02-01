`ifndef DEFINITIONS
`define DEFINITIONS

`define L(bits,i) ((bits)*((i)+1) - 1)
`define R(bits,i) ((bits)*(i))

`define BITS 8
`define I_WIDTH 8
`define O_WIDTH 16

// Number of pixel data addresses on each row of the display
`define ADDRESSES_PER_ROW 160
// Total number of addresses in the framestore
`define TOTAL_ADDRESSES 76800

// Coefficients for sobel convolution filter
`define SOBEL_COEFFICIENTS 36'hF01E02F01
// Threshold used for sobel convolution output
`define SOBEL_THRESHOLD 7

// Coefficients for gaussian blur convolution filter
`define GAUSSIAN_COEFFICIENTS 36'h121242121
// Gaussian filter output should be divided by 16 (shift by 4)
`define GAUSSIAN_OUTPUT_SHIFT 4

// Ugly hack to get logarithm, because the built in function '$clog2()'
// doesn't play nicely with synthesis for some reason.
`define LOG2(x) \
   (x <= 2) ? 1 \
   : (x <= 4) ? 2 \
   : (x <= 8) ? 3 \
   : (x <= 16) ? 4 \
   : (x <= 32) ? 5 \
   : (x <= 64) ? 6 \
   : (x <= 128) ? 7 \
   : (x <= 256) ? 8 \
   : (x <= 512) ? 9 \
   : (x <= 1024) ? 10 \
   : -1

`endif