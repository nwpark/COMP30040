`ifndef RELU_LAYER
`define RELU_LAYER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/relu_layer/relu_unit.sv"

module relu_layer #(
  parameter I_WIDTH = -1,
  parameter CHANNELS = -1
)(
  input wire  [I_WIDTH*CHANNELS-1:0] input_data,
  output wire [I_WIDTH*CHANNELS-1:0] output_data
);

  // Internal signals / buses
  genvar i;

  // Relu unit for each input channel
  generate
    for (i = 0; i < CHANNELS; i = i+1) begin : input_channels
      relu_unit #(
        .I_WIDTH(I_WIDTH)
      ) relu (
        .input_data(input_data[I_WIDTH*i +: I_WIDTH]),
        .output_data(output_data[I_WIDTH*i +: I_WIDTH])
      );
    end
  endgenerate

endmodule

`endif