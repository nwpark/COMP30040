`ifndef MAX_POOL
`define MAX_POOL

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module max_pooling_unit #(
  parameter SIZE = -1,
  parameter D_WIDTH = -1
)(
  input  wire [D_WIDTH*SIZE-1:0] input_data,
  output wire [D_WIDTH-1     :0] output_data
);

  genvar i;

  wire [D_WIDTH-1:0] comparisons [SIZE-1:0];

  assign comparisons[0] = input_data[D_WIDTH-1:0];

  // Generate comparator tree
  generate
    for(i = 0; i < SIZE+1; i=i+1) begin : compare
      assign comparisons[i+1]
        = comparisons[i] > input_data[D_WIDTH*(i+1) +: D_WIDTH]
          ? comparisons[i]
          : input_data[D_WIDTH*(i+1) +: D_WIDTH];
    end
  endgenerate

  assign output_data = comparisons[SIZE-1];

endmodule

`endif