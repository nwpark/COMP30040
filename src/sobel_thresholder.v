//------------------------------------------------------------------------------
//           Verilog module for sobel_thresholder.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Outputs a white pixel if the absolute value of the input is greater
// than the threshold, else outputs a black pixel.
//
// Parameters:
// Threshold - threshold value to output a white, or a black pixel.
//------------------------------------------------------------------------------

`ifndef THRESHOLDER
`define THRESHOLDER

module sobel_thresholder (
    input wire signed [9:0] red_input,
    input wire signed [9:0] green_input,
    input wire signed [9:0] blue_input,
    output reg [7:0] output_data
  );

  parameter THRESHOLD = 0;

  // Sum of color channels
  reg signed [11:0] sum;

  // Absolute value of sum
  reg [10:0] abs_sum;

  // Apply threshold to input data
  always @ (*)
  begin
    // Sum [red, green, blue] color channels
    sum = red_input + green_input + blue_input;

    // Take absolute value of sum
    abs_sum = sum[11] ? -sum : sum;

    // Apply threshold
    if (abs_sum > THRESHOLD)
      output_data = 8'hFF;
    else
      output_data = 8'h00;
  end

endmodule

`endif