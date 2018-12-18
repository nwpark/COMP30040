//------------------------------------------------------------------------------
//           Verilog module for fifo_controller.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// This module provides a controller to generate read and write addresses such
// that an attached BLOCK RAM will behave as a FIFO buffer.
//
// Paramaters:
// SIZE - Size of buffer to control (number of words).
//------------------------------------------------------------------------------

`ifndef CONV_BUFF_CTRL
`define CONV_BUFF_CTRL

module fifo_controller #(
    parameter SIZE = 256
  )(
    input wire clk,
    input wire clk_en,
    output reg [(`LOG2(SIZE))-1:0] rd_addr,
    output reg [(`LOG2(SIZE))-1:0] wr_addr
  );

  // Initial address for read and write ports (convenient for FPGA)
  // (read addr will always remain [SIZE-1] addresses behind write addr)
  initial rd_addr = 1;
  initial wr_addr = 0;

  always @ (posedge clk) begin
    if(clk_en) begin
      // Increment read address
      if (rd_addr == SIZE-1) rd_addr <= 0;
      else rd_addr <= rd_addr + 1;

      // Increment write address
      if (wr_addr == SIZE-1) wr_addr <= 0;
      else wr_addr <= wr_addr + 1;
    end
  end

endmodule

`endif