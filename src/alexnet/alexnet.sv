`ifndef ALEXNET
`define ALEXNET

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module alexnet (
  input wire  clk,
  input wire  clk_en,
  input wire  input_data,
  output wire output_data,
);

  // These are just dummy layers (not actually alexnet)

  convolutional_layer #(
    .D_WIDTH(8),
    .Q_WIDTH(16),
    .D_CHANNELS(3),
    .Q_CHANNELS(5),
    .FILTER_SIZE(2),
    .IMAGE_SIZE(256),
    .STRIDE(1),
    .FILEPATH("/home/mbyx4np3/COMP30040/COMP30040/data/alexnet/layer_0")
  ) layer_0 (
    .clk(clk),
    .clk_en(clk_en),
    .input_data(input_data),
    .output_data(output_data),
    .valid(valid)
  );

  pooling_layer #(
    .D_WIDTH(D_WIDTH),
    .CHANNELS(CHANNELS),
    .FILTER_SIZE(FILTER_SIZE),
    .IMAGE_SIZE(IMAGE_WIDTH),
    .STRIDE(STRIDE)
  ) pool_layer (
    .clk(clk),
    .clk_en(clk_en),
    .input_data(input_data),
    .output_data(output_data),
    .valid(valid)
  );

endmodule
