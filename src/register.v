//------------------------------------------------------------------------------
//           Verilog module for register.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Simple register.
//
// Paramaters:
// SIZE - Size of register (number of bits).
//------------------------------------------------------------------------------

`ifndef REG32
`define REG32

module register #(
    parameter SIZE = 32
  )(
    input wire clk,
		input wire clk_en,
		input wire [SIZE-1:0] D,
		output reg [SIZE-1:0] Q
	);

  always @(posedge clk)
    if (clk_en)
      Q <= D;

endmodule

`endif