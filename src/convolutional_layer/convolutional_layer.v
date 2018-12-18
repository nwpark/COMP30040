`ifndef CONV_LAYER
`define CONV_LAYER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/pixel_buffer/pixel_buffer_controller.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/pixel_buffer/pixel_buffer.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/convolutional_layer/inner_product_unit.v"

module convolutional_layer #(
  parameter D_WIDTH = -1,
  parameter Q_WIDTH = -1,
  parameter D_CHANNELS = -1,
  parameter Q_CHANNELS = -1,
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1
)(
  input wire                           clk,
  input wire                           clk_en,
  input wire  [D_WIDTH*D_CHANNELS-1:0] input_data,
  output wire [Q_WIDTH*Q_CHANNELS-1:0] output_data,
  output wire                          valid
);

  // Bits per convolution window
  parameter CONV_WIDTH = D_WIDTH*FILTER_SIZE*FILTER_SIZE;

  // Internal signals / buses
  wire [CONV_WIDTH-1:0] pixel_buff_out [D_CHANNELS-1:0];

  wire [(`LOG2(IMAGE_SIZE))-1:0] buffer_wr_addr;
  wire [(`LOG2(IMAGE_SIZE))-1:0] buffer_rd_addr;

  genvar i;
  genvar j;

  // Pixel buffer controller
  pixel_buffer_controller #(
    .IMAGE_SIZE(IMAGE_SIZE),
    .FILTER_SIZE(FILTER_SIZE)
  ) controller (
    .clk(clk),
    .clk_en(clk_en),
    .rd_addr(buffer_rd_addr),
    .wr_addr(buffer_wr_addr),
    .valid(valid)
  );

  // Pixel buffer for each input channel
  generate
    for (i = 0; i < D_CHANNELS; i = i+1) begin : registers
      pixel_buffer #(
        .FILTER_SIZE(FILTER_SIZE),
        .IMAGE_SIZE(IMAGE_SIZE),
        .D_WIDTH(D_WIDTH)
      ) pixel_buff (
        .clk(clk),
        .clk_en(clk_en),
        .buffer_wr_addr(buffer_wr_addr),
        .buffer_rd_addr(buffer_rd_addr),
        .input_data(input_data[`L(D_WIDTH, i):`R(D_WIDTH, i)]),
        .output_data(pixel_buff_out[i])
      );
    end
  endgenerate

  // Inner product units for each output channel
  generate
    for (i = 0; i < Q_CHANNELS; i = i+1) begin : output_channels
      for (j = 0; j < D_CHANNELS; j = j+1) begin : input_channels
        inner_product_unit #(
          .SIZE(FILTER_SIZE*FILTER_SIZE),
          .D_WIDTH(D_WIDTH),
          .Q_WIDTH(Q_WIDTH)
        ) inner_product (
          .input_data(pixel_buff_out[i][`L(CONV_WIDTH, j):`R(CONV_WIDTH, j)]),
          .output_data(output_data[`L(Q_WIDTH, j):`R(Q_WIDTH, j)])
        );
      end
    end
  endgenerate

endmodule

`endif