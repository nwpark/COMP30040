`ifndef RELU_LAYER
`define RELU_LAYER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module relu_layer #(
  parameter D_WIDTH = -1,
  parameter CHANNELS = -1
)(
  input wire                         clk,
  input wire                         clk_en,
  input wire  [D_WIDTH*CHANNELS-1:0] input_data,
  output wire [D_WIDTH*CHANNELS-1:0] output_data
);

  // Internal signals / buses
  genvar i;

  // Relu unit for each input channel
  generate
    for (i = 0; i < CHANNELS; i = i+1) begin : input_channels
      relu_unit #(
        .D_WIDTH(D_WIDTH)
      ) relu (
        .input_data(input_data[D_WIDTH*i +: D_WIDTH]),
        .output_data(output_data[D_WIDTH*i +: D_WIDTH])
      );
    end
  endgenerate

endmodule

`endif