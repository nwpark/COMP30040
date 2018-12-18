//------------------------------------------------------------------------------
//           Verilog module for da_rom_9.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Distributed Artithmetic ROM with a 9-bit address. The ROM conforms to the
// specification described in section 1.4 of the attached report. This
// module creates a DA ROM with a 9 bit address by combining three DA ROMs
// with 3 bit addresses.
//
// Parameters:
// COEFFICIENTS - Coefficients to use for the convolution filter.
//------------------------------------------------------------------------------

`include "/home/mbyx4np3/COMP32211/src/distributed_arithmetic/da_rom_3.v"

// Max possible output value is 8 bits accounting for sign
module da_rom_9 #(
    parameter COEFFICIENTS = 36'h000010000
  )(
    input wire         [8:0] addr,
    output wire signed [7:0] output_data
  );

  // Output from the partial ROMs
  wire signed [5:0] results [2:0];

  // Accumulate results from each of the partial ROMs
  assign output_data = results[0] + results[1] + results[2];

  // Generate three partial ROMs (refer to section 1.4 of the report for an
  // explanation for why the number three was chosen)
  genvar i;
  generate
  for (i=0; i<3; i=i+1) begin: rom
    da_rom_3 #(
      .COEFFICIENT_0(COEFFICIENTS[3+i*12:0+i*12]),
      .COEFFICIENT_1(COEFFICIENTS[7+i*12:4+i*12]),
      .COEFFICIENT_2(COEFFICIENTS[11+i*12:8+i*12])
    ) da_rom (
      .addr(addr[2+i*3:0+i*3]),
      .output_data(results[i])
    );
  end
  endgenerate

endmodule