`ifndef PIXEL_BUFF_CTRL
`define PIXEL_BUFF_CTRL

// TODO: address bus is bigger than it needs to be
module pixel_buffer_controller #(
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1
)(
  input wire                           clk,
  input wire                           clk_en,
  output reg [(`LOG2(IMAGE_SIZE))-1:0] rd_addr,
  output reg [(`LOG2(IMAGE_SIZE))-1:0] wr_addr,
  output reg                           valid
);

  // TODO: these bus widths are totally off
  reg [(`LOG2(IMAGE_SIZE))-1:0] x;
  reg [(`LOG2(IMAGE_SIZE))-1:0] y;

  initial rd_addr = 1;
  initial wr_addr = 0;
  initial x = 0;
  initial y = 0;

  always @(posedge clk) begin
    if (clk_en) begin
      // Increment read address
      if (rd_addr == IMAGE_SIZE-FILTER_SIZE) rd_addr <= 0;
      else rd_addr <= rd_addr+1;

      // Increment write address
      if (wr_addr == IMAGE_SIZE-FILTER_SIZE) wr_addr <= 0;
      else wr_addr <= wr_addr+1;

      // Increment x
      if (x == IMAGE_SIZE-1) begin
        x <= 0;
        y <= y+1;
      end
      else begin
        x <= x+1;
      end

      valid <= (y >= FILTER_SIZE-1) && (x >= FILTER_SIZE-1);
    end
  end

endmodule

`endif