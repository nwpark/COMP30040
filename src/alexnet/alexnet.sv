`ifndef ALEXNET
`define ALEXNET

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module alexnet (
  input wire         clk,
  input wire         clk_en,
  input wire  [48:0] input_data,
  output wire [80:0] output_data,
  output wire        valid
);

  // Internal signals / buses
  wire [80:0] layer_0_output;
  wire        layer_0_valid;
  wire [80:0] layer_1_output;

  // Convolutional layer
  convolutional_layer #(
    .I_WIDTH(8),
    .O_WIDTH(16),
    .CHANNELS_IN(3),
    .CHANNELS_OUT(5),
    .FILTER_SIZE(2),
    .IMAGE_SIZE(256),
    .STRIDE(1),
    .FILEPATH("/home/mbyx4np3/COMP30040/COMP30040/data/alexnet/layer_0")
  ) layer_0 (
    .clk(clk),
    .clk_en(clk_en),
    .input_data(input_data),
    .output_data(layer_0_output),
    .valid(layer_0_valid)
  );

  // Relu layer
  relu_layer #(
    .I_WIDTH(16),
    .CHANNELS(5)
  ) layer_1 (
    .input_data(layer_0_output),
    .output_data(layer_1_output)
  );

  // Pooling layer
  pooling_layer #(
    .I_WIDTH(8),
    .CHANNELS(5),
    .FILTER_SIZE(2),
    .IMAGE_SIZE(254),
    .STRIDE(2)
  ) layer_2 (
    .clk(clk),
    .clk_en(layer_0_valid),
    .input_data(layer_1_output),
    .output_data(output_data),
    .valid(valid)
  );

endmodule
