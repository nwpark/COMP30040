//------------------------------------------------------------------------------
//           Verilog module for da_unit.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Computes the inner product of 9 input pixel values with the coefficients,
// using the distributed arithmetic algorithm detailed in section 1.4 of the
// attached report.
//
// Parameters:
// COEFFICIENTS - Coefficients to use for the convolution filter.
//------------------------------------------------------------------------------

`include "/home/mbyx4np3/COMP32211/src/distributed_arithmetic/da_rom_9.v"

module da_unit (
    input  wire        [26:0] pixel_values,
    output wire signed  [9:0] output_data
  );

  // Filter coefficients
  parameter COEFFICIENTS = 36'h000010000;

  // Output from the DA ROMs
  wire signed [7:0] da_out [2:0];

  // Accumulate results from the DA ROMs, shifting the results appropriately.
  assign output_data = da_out[0] + (da_out[1] << 1) + (da_out[2] << 2);

  // Generate a DA ROM for each bit of the input pixels
  genvar i;
  generate
  for (i=0; i<3; i=i+1) begin: rom
    da_rom_9 #(
      .COEFFICIENTS(COEFFICIENTS)
    ) da_rom (
      .addr({pixel_values[i+24], pixel_values[i+21], pixel_values[i+18],
             pixel_values[i+15], pixel_values[i+12], pixel_values[i+9],
             pixel_values[i+6], pixel_values[i+3], pixel_values[i]}),
      .output_data(da_out[i])
    );
  end
  endgenerate

endmodule