//------------------------------------------------------------------------------
//           Verilog module for sobel_filter.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// This module takes 9 input RGB pixels, and computes the output by applying
// convolution using a sobel filter.
//------------------------------------------------------------------------------

`ifndef SOBEL_FILTER
`define SOBEL_FILTER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/convolution_filter.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/sobel_thresholder.v"

module sobel_filter (
    input  wire [71:0] pixel_values,
    output wire [7:0] output_data
  );

  // Convolution output on [red, green, blue] color channels
  wire signed [9:0] red_output;
  wire signed [9:0] green_output;
  wire signed [9:0] blue_output;

  // Instantiate convolution filter with sobel coefficients
  convolution_filter #(
    .COEFFICIENTS(`SOBEL_COEFFICIENTS)
  ) sobel (
    .pixel_values(pixel_values),
    .red_output(red_output),
    .green_output(green_output),
    .blue_output(blue_output)
  );

  // Instantiate thresholder to apply threshold on the sobel convolution output
  sobel_thresholder #(
    .THRESHOLD(`SOBEL_THRESHOLD)
  ) sobel_thresholder (
    .red_input(red_output),
    .green_input(green_output),
    .blue_input(blue_output),
    .output_data(output_data)
  );

endmodule

`endif