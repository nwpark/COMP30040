//------------------------------------------------------------------------------
//           Verilog module for convolution_filter.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// This module takes 9 input RGB pixels, computes the convolution output for
// each color channel (red, green, blue) and outputs the result for each
// channel.
//
// Parameters:
// COEFFICIENTS - Coefficients to use for the convolution filter.
//------------------------------------------------------------------------------

`ifndef CONV_FILTER_RGB
`define CONV_FILTER_RGB

`include "/home/mbyx4np3/COMP30040/COMP30040/src/distributed_arithmetic/da_unit.v"

module convolution_filter (
    input  wire [71:0] pixel_values,
    output wire signed [9:0] red_output,
    output wire signed [9:0] green_output,
    output wire signed [9:0] blue_output
  );

  // Filter coefficients
  parameter COEFFICIENTS = 36'h000010000;

  // Inner product on red channel
  da_unit #(
    .COEFFICIENTS(COEFFICIENTS)
  ) red (
    .pixel_values({
      red_value(pixel_values[71:64]),
      red_value(pixel_values[63:56]),
      red_value(pixel_values[55:48]),
      red_value(pixel_values[47:40]),
      red_value(pixel_values[39:32]),
      red_value(pixel_values[31:24]),
      red_value(pixel_values[23:16]),
      red_value(pixel_values[15:8]),
      red_value(pixel_values[7:0])
    }),
    .output_data(red_output)
  );

  // Inner product on green channel
  da_unit #(
    .COEFFICIENTS(COEFFICIENTS)
  ) green (
    .pixel_values({
      green_value(pixel_values[71:64]),
      green_value(pixel_values[63:56]),
      green_value(pixel_values[55:48]),
      green_value(pixel_values[47:40]),
      green_value(pixel_values[39:32]),
      green_value(pixel_values[31:24]),
      green_value(pixel_values[23:16]),
      green_value(pixel_values[15:8]),
      green_value(pixel_values[7:0])
    }),
    .output_data(green_output)
  );

  // Inner product on blue channel
  da_unit #(
    .COEFFICIENTS(COEFFICIENTS)
  ) blue (
    .pixel_values({
      blue_value(pixel_values[71:64]),
      blue_value(pixel_values[63:56]),
      blue_value(pixel_values[55:48]),
      blue_value(pixel_values[47:40]),
      blue_value(pixel_values[39:32]),
      blue_value(pixel_values[31:24]),
      blue_value(pixel_values[23:16]),
      blue_value(pixel_values[15:8]),
      blue_value(pixel_values[7:0])
    }),
    .output_data(blue_output)
  );

  // Extract red channel from a pixel
  function [2:0] red_value;
    input [7:0] pixel;
    red_value = pixel[7:5];
  endfunction

  // Extract green channel from a pixel
  function [2:0] green_value;
    input [7:0] pixel;
    green_value = pixel[4:2];
  endfunction

  // Extract blue channel from a pixel
  // (convert 2 bit color to 3 bit by shifting left and setting lsb = msb)
  function [2:0] blue_value;
    input [7:0] pixel;
    blue_value = {pixel[1:0],pixel[1]};
  endfunction

endmodule

`endif