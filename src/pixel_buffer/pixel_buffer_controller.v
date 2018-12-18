`ifndef PIXEL_BUFF_CTRL
`define PIXEL_BUFF_CTRL

module pixel_buffer_controller #(
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1
)(
  input wire                            clk,
  input wire                            clk_en,
  output reg [(`LOG2(IMAGE_SIZE))-1:0] rd_addr,
  output reg [(`LOG2(IMAGE_SIZE))-1:0] wr_addr,
  output reg                            valid
);

  reg [(`LOG2(IMAGE_SIZE))-1:0] x;

  initial rd_addr = 1;
  initial wr_addr = 0;
  initial x = 0;

  always @(posedge clk) begin
    if (clk_en) begin
      // Increment read address
      if (rd_addr == IMAGE_SIZE-FILTER_SIZE) rd_addr <= 0;
      else rd_addr <= rd_addr+1;

      // Increment write address
      if (wr_addr == IMAGE_SIZE-FILTER_SIZE) wr_addr <= 0;
      else wr_addr <= wr_addr+1;

      // Increment x
      if (x == IMAGE_SIZE-1) x <= 0;
      else x <= x+1;

      valid <= (x >= FILTER_SIZE);
    end
  end

endmodule

`endif