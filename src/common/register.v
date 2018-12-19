//------------------------------------------------------------------------------
//           Verilog module for register.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Simple register.
//
// Paramaters:
// WIDTH - Size of register (number of bits).
//------------------------------------------------------------------------------

`ifndef REG
`define REG

module register #(
    parameter WIDTH = -1
  )(
    input wire            clk,
		input wire            clk_en,
		input wire [WIDTH-1:0] D,
		output reg [WIDTH-1:0] Q
	);

  always @(posedge clk)
    if (clk_en)
      Q <= D;

endmodule

`endif