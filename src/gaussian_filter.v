//------------------------------------------------------------------------------
//           Verilog module for gaussian_filter.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// This module takes 9 input RGB pixels, and computes the output by applying
// convolution using a gaussian filter.
// The result of the gaussian filter is divided by 16 with a shift operation.
//------------------------------------------------------------------------------

`ifndef GAUSS_FILTER
`define GAUSS_FILTER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/convolution_filter.v"

module gaussian_filter (
    input  wire [71:0] pixel_values,
    output wire [7:0] output_data
  );

  // Convolution output on [red, green, blue] color channels
  wire signed [9:0] red_output;
  wire signed [9:0] green_output;
  wire signed [9:0] blue_output;

  // Concatenate [red, green, blue] color channels for output
  // (convert blue to 2 bits by discarding least significant bit)
  assign output_data
    = {red_output[2+`GAUSSIAN_OUTPUT_SHIFT:`GAUSSIAN_OUTPUT_SHIFT],
       green_output[2+`GAUSSIAN_OUTPUT_SHIFT:`GAUSSIAN_OUTPUT_SHIFT],
       blue_output[2+`GAUSSIAN_OUTPUT_SHIFT:1+`GAUSSIAN_OUTPUT_SHIFT]};

  // Instantiate convolution filter with gaussian coefficients
  convolution_filter #(
    .COEFFICIENTS(`GAUSSIAN_COEFFICIENTS)
  ) gaussian (
    .pixel_values(pixel_values),
    .red_output(red_output),
    .green_output(green_output),
    .blue_output(blue_output)
  );

endmodule

`endif