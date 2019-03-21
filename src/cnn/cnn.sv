`ifndef CNN
`define CNN

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/convolutional_layer/convolutional_layer.sv"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/relu_layer/relu_layer.sv"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/pooling_layer/pooling_layer.v"

module cnn (
  input wire         clk,
  input wire         clk_en,
  input wire  [23:0] input_data,
  output wire [79:0] output_data,
  output wire        valid
);

  wire [79:0] layer_0_output;
  wire [79:0] layer_1_output;
  wire        layer_0_valid;

  // Convolutional layer
  convolutional_layer #(
    .I_WIDTH(8),
    .O_WIDTH(16),
    .CHANNELS_IN(3),
    .CHANNELS_OUT(5),
    .FILTER_SIZE(5),
    .IMAGE_SIZE(64),
    .STRIDE(4),
    .FILEPATH("/home/mbyx4np3/COMP30040/COMP30040/data/cnn/layer_0")
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
    .I_WIDTH(16),
    .CHANNELS(5),
    .FILTER_SIZE(2),
    .IMAGE_SIZE(15),
    .STRIDE(2)
  ) layer_2 (
    .clk(clk),
    .clk_en(layer_0_valid),
    .input_data(layer_1_output),
    .output_data(output_data),
    .valid(valid)
  );

endmodule

`endif
