`ifndef MAX_POOL
`define MAX_POOL

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module max_pooling_unit #(
  parameter SIZE = -1,
  parameter I_WIDTH = -1
)(
  input  wire [I_WIDTH*SIZE-1:0] input_data,
  output wire [I_WIDTH-1     :0] output_data
);

  genvar i;

  wire [I_WIDTH-1:0] comparisons [SIZE-1:0];

  assign comparisons[0] = input_data[I_WIDTH-1:0];

  // Generate comparator tree
  generate
    for(i = 0; i < SIZE+1; i=i+1) begin : compare
      assign comparisons[i+1]
        = comparisons[i] > input_data[I_WIDTH*(i+1) +: I_WIDTH]
          ? comparisons[i]
          : input_data[I_WIDTH*(i+1) +: I_WIDTH];
    end
  endgenerate

  assign output_data = comparisons[SIZE-1];

endmodule

`endif