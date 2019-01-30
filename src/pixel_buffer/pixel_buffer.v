`ifndef PIXEL_BUFFER
`define PIXEL_BUFFER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/block_ram.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/register.v"

module pixel_buffer #(
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1,
  parameter D_WIDTH = -1
)(
  input wire                                        clk,
  input wire                                        clk_en,
  input wire  [(`LOG2(IMAGE_SIZE))-1            :0] buffer_wr_addr,
  input wire  [(`LOG2(IMAGE_SIZE))-1            :0] buffer_rd_addr,
  input wire  [D_WIDTH-1                        :0] input_data,
  output wire [D_WIDTH*FILTER_SIZE*FILTER_SIZE-1:0] output_data
);

  // Internal signals / buses
  wire [D_WIDTH*FILTER_SIZE-1:0] data [FILTER_SIZE-1:0];
  genvar i, j;

  // Assign input data to input of pixel register
  assign data[FILTER_SIZE-1][D_WIDTH*(FILTER_SIZE-1) +: D_WIDTH] = input_data;

  // Registers for each row
  generate
    for (i = 0; i < FILTER_SIZE; i = i+1) begin : registers_i
      for (j = 0; j < FILTER_SIZE-1; j = j+1) begin : registers_j
        register #(
          .WIDTH(D_WIDTH)
        ) pixel_reg (
          .clk(clk),
          .clk_en(clk_en),
          .D(data[i][D_WIDTH*(j+1) +: D_WIDTH]),
          .Q(data[i][D_WIDTH*(j)   +: D_WIDTH])
        );
      end
    end
  endgenerate

  // Line buffer for each row
  generate
    for (i = 0; i < FILTER_SIZE-1; i = i+1) begin : buffers
      block_ram #(
        .WIDTH(D_WIDTH),
        .DEPTH(IMAGE_SIZE-(FILTER_SIZE-1))
      ) line_buffer (
        .clk(clk),
        .clk_en(clk_en),
        .wr_addr(buffer_wr_addr),
        .wr_data(data[i+1][D_WIDTH-1:0]),
        .rd_addr(buffer_rd_addr),
        .rd_data(data[i][D_WIDTH*(FILTER_SIZE-1) +: D_WIDTH])
      );
    end
  endgenerate

  // Assign output data
  generate
    for (i = 0; i < FILTER_SIZE; i = i+1) begin : out_data
      assign output_data[FILTER_SIZE*D_WIDTH*i +: FILTER_SIZE*D_WIDTH] = data[i];
    end
  endgenerate

endmodule

`endif