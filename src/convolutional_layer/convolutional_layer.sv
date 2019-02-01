`ifndef CONV_LAYER
`define CONV_LAYER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/line_buffer/line_buffer_controller.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/line_buffer/line_buffer.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/convolutional_layer/inner_product_unit.sv"

module convolutional_layer #(
  parameter I_WIDTH = -1,
  parameter O_WIDTH = -1,
  parameter CHANNELS_IN = -1,
  parameter CHANNELS_OUT = -1,
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1,
  parameter STRIDE = -1,
  parameter FILEPATH = -1
)(
  input wire                           clk,
  input wire                           clk_en,
  input wire  [I_WIDTH*CHANNELS_IN-1:0] input_data,
  output wire [O_WIDTH*CHANNELS_OUT-1:0] output_data,
  output wire                          valid
);

  // Internal signals / buses
  wire [I_WIDTH*(FILTER_SIZE**2)-1:0] line_buff_out      [CHANNELS_IN-1:0];
  wire [O_WIDTH*CHANNELS_OUT-1      :0] inner_products     [CHANNELS_IN-1:0];
  wire [O_WIDTH*CHANNELS_OUT-1      :0] inner_products_sum [CHANNELS_IN-1:0];

  wire [(`LOG2(IMAGE_SIZE))-1     :0] buffer_wr_addr;
  wire [(`LOG2(IMAGE_SIZE))-1     :0] buffer_rd_addr;

  genvar i, j;

  // Line buffer controller
  line_buffer_controller #(
    .IMAGE_SIZE(IMAGE_SIZE),
    .FILTER_SIZE(FILTER_SIZE),
    .STRIDE(STRIDE)
  ) controller (
    .clk(clk),
    .clk_en(clk_en),
    .rd_addr(buffer_rd_addr),
    .wr_addr(buffer_wr_addr),
    .valid(valid)
  );

  // Line buffer for each input channel
  generate
    for (i = 0; i < CHANNELS_IN; i = i+1) begin : registers
      line_buffer #(
        .FILTER_SIZE(FILTER_SIZE),
        .IMAGE_SIZE(IMAGE_SIZE),
        .I_WIDTH(I_WIDTH)
      ) line_buff (
        .clk(clk),
        .clk_en(clk_en),
        .buffer_wr_addr(buffer_wr_addr),
        .buffer_rd_addr(buffer_rd_addr),
        .input_data(input_data[I_WIDTH*i +: I_WIDTH]),
        .output_data(line_buff_out[i])
      );
    end
  endgenerate

  // Inner product units for each output channel
  generate
    for (i = 0; i < CHANNELS_OUT; i = i+1) begin : output_channels
      for (j = 0; j < CHANNELS_IN; j = j+1) begin : input_channels
        inner_product_unit #(
          .SIZE(FILTER_SIZE**2),
          .I_WIDTH(I_WIDTH),
          .O_WIDTH(O_WIDTH),
          .FILEPATH(FILEPATH),
          .FILEINDEX_I(i),
          .FILEINDEX_J(j)
        ) inner_product (
          .input_data(line_buff_out[j]),
          .output_data(inner_products[j][O_WIDTH*i +: O_WIDTH])
        );
      end
    end
  endgenerate

  // Adder tree for inner product units
  assign inner_products_sum[0] = inner_products[0];
  generate
    for(i = 0; i < CHANNELS_IN-1; i=i+1) begin : input_channels
      for(j = 0; j < CHANNELS_OUT; j=j+1) begin : output_channels
        assign inner_products_sum[i+1][O_WIDTH*j +: O_WIDTH]
          = inner_products_sum[i][O_WIDTH*j +: O_WIDTH]
            + inner_products[i+1][O_WIDTH*j +: O_WIDTH];
      end
    end
  endgenerate
  assign output_data = inner_products_sum[CHANNELS_IN-1];

endmodule

`endif