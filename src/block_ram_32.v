//------------------------------------------------------------------------------
//           Verilog module for block_ram_32.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Dual port BLOCK RAM.
//
// Paramaters:
// SIZE - Size of RAM (number of words).
//------------------------------------------------------------------------------

`ifndef BRAM_32
`define BRAM_32

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

// XST Constraint to guarantee this gets mapped to a BLOCK RAM primitive.
(* RAM_STYLE="BLOCK" *)
module block_ram_32 #(
    parameter SIZE = 256
  )(
    input  wire clk,
    input  wire clk_en,
    input  wire [(`LOG2(SIZE))-1:0] wr_addr,
    input  wire [31:0] wr_data,
    input  wire [(`LOG2(SIZE))-1:0] rd_addr,
    output reg  [31:0] rd_data
  );

  // Block RAM
  reg [31:0] memory [0:SIZE-1];

  always @ (posedge clk) begin
    if(clk_en) begin
      // Write input data to Block RAM
      memory[wr_addr] <= wr_data;
      // Read output data from Block RAM
      rd_data <= memory[rd_addr];
    end
  end

endmodule

`endif