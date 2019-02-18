`ifndef LINE_BUFF_CTRL
`define LINE_BUFF_CTRL

// TODO: address bus is bigger than it needs to be
module line_buffer_controller #(
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1,
  parameter STRIDE = -1
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
  reg [(`LOG2(STRIDE))-1    :0] stride_x;
  reg [(`LOG2(STRIDE))-1    :0] stride_y;

  initial rd_addr = 1;
  initial wr_addr = 0;
  initial x = 0;
  initial y = 0;
  initial stride_x = 0;
  initial stride_y = 0;

  // Determine output read and write addresses
  always @(posedge clk) begin
    if (clk_en) begin
      // Increment read address
      if (rd_addr == IMAGE_SIZE-FILTER_SIZE) rd_addr <= 0;
      else rd_addr <= rd_addr+1;

      // Increment write address
      if (wr_addr == IMAGE_SIZE-FILTER_SIZE) wr_addr <= 0;
      else wr_addr <= wr_addr+1;
    end
  end

  // Determine whether output is valid
  always @(posedge clk) begin
    if (clk_en) begin
      // Update x and y
      if (x == IMAGE_SIZE-1) begin
        x <= 0;
        y <= y+1;

        // Update stride_y
        if (stride_y == STRIDE-1 || y < FILTER_SIZE-1) stride_y <= 0;
        else stride_y <= stride_y + 1;
      end
      else begin
        x <= x+1;
      end

      // Update stride_x
      if (stride_x == STRIDE-1 || x < FILTER_SIZE-1) stride_x <= 0;
      else stride_x <= stride_x + 1;

      // Determine validity
      valid <= (y >= FILTER_SIZE-1)
        && (x >= FILTER_SIZE-1)
        && (stride_x == 0)
        && (stride_y == 0);
    end
  end

endmodule

`endif