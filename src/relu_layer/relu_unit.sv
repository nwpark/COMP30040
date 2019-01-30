`ifndef RELU_UNIT
`define RELU_UNIT

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module relu_unit #(
  parameter D_WIDTH = -1
)(
  input  wire [D_WIDTH-1:0] input_data,
  output wire [D_WIDTH-1:0] output_data
);

  assign output_data = input_data > 0 ? input_data : output_data;

endmodule

`endif