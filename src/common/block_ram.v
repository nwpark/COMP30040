`ifndef BRAM
`define BRAM

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

(* RAM_STYLE = "BLOCK" *)
module block_ram #(
  parameter WIDTH = -1,
  parameter DEPTH = -1
)(
  input wire clk,
  input wire clk_en,
  input wire [(`LOG2(DEPTH))-1:0] wr_addr,
  input wire [WIDTH-1:0] wr_data,
  input wire [(`LOG2(DEPTH))-1:0] rd_addr,
  output reg [WIDTH-1:0] rd_data
);

  // Block RAM
  reg [WIDTH-1:0] memory [0:DEPTH-1];

  always @(posedge clk) begin
    if (clk_en) begin
      // Write input data to Block RAM
      memory[wr_addr] <= wr_data;
      // Read output data from Block RAM
      rd_data <= memory[rd_addr];
    end
  end

endmodule

`endif