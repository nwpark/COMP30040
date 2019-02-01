`ifndef RELU_UNIT
`define RELU_UNIT

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module relu_unit #(
  parameter I_WIDTH = -1
)(
  input  wire signed [I_WIDTH-1:0] input_data,
  output wire signed [I_WIDTH-1:0] output_data
);

  assign output_data = input_data > 0 ? input_data : 0;

endmodule

`endif