`ifndef MAX_POOL
`define MAX_POOL

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module max_pooling_unit #(
  parameter SIZE = -1
)(
  input  wire        [16*SIZE-1:0] input_data,
  output wire signed [16-1     :0] output_data
);

  genvar k;

  wire signed [16-1:0] comparisons [SIZE-1:0];

  assign comparisons[0] = input_data[16-1:0];

  // Generate comparator tree
  generate
    for (k=0; k<5; k=k+1) begin : POOL
      wire signed [16-1:0] val = input_data[16*(k+1) +: 16];
      assign comparisons[k+1]
        = comparisons[k] > val ? comparisons[k] : val;
    end
  endgenerate

  assign output_data = comparisons[SIZE-1];

endmodule

`endif