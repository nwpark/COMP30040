`ifndef PIXEL_BUFFER
`define PIXEL_BUFFER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/block_ram.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/register.v"

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
  genvar i;
  genvar j;

  // Assign output data
  generate
    for (i = 0; i < FILTER_SIZE; i = i+1) begin : out_data
      assign output_data[`L(FILTER_SIZE*D_WIDTH, i):`R(FILTER_SIZE*D_WIDTH, i)] = data[i];
    end
  endgenerate

  assign data[FILTER_SIZE-1][`L(D_WIDTH, FILTER_SIZE-1):`R(D_WIDTH, FILTER_SIZE-1)] = input_data;

  // Registers for each row
  generate
    for (i = 0; i < FILTER_SIZE; i = i+1) begin : registers_i
      for (j = 0; j < FILTER_SIZE-1; j = j+1) begin : registers_j
        register#(
          .SIZE(D_WIDTH)
        ) pixel_reg (
          .clk(clk),
          .clk_en(clk_en),
          .D(data[i][`L(D_WIDTH, j+1):`R(D_WIDTH, j+1)]),
          .Q(data[i][`L(D_WIDTH, j)  :`R(D_WIDTH, j)])
        );
      end
    end
  endgenerate

  // Line buffer for each row
  generate
    for (i = 0; i < FILTER_SIZE-1; i = i+1) begin : buffers
      block_ram #(
        .WIDTH(D_WIDTH),
        .SIZE(IMAGE_SIZE-(FILTER_SIZE-1))
      ) fifo_buffer(
        .clk(clk),
        .clk_en(clk_en),
        .wr_addr(buffer_wr_addr),
        .wr_data(data[i+1][D_WIDTH-1:0]),
        .rd_addr(buffer_rd_addr),
        .rd_data(data[i][`L(D_WIDTH, FILTER_SIZE-1):`R(D_WIDTH, FILTER_SIZE-1)])
      );
    end
  endgenerate

endmodule

`endif