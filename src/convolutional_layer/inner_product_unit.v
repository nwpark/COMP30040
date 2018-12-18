`ifndef INNER_PROD
`define INNER_PROD

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module inner_product_unit #(
  parameter SIZE = -1,
  parameter COEFFICIENTS = 'h01010101,
  parameter D_WIDTH = -1,
  parameter Q_WIDTH = -1
)(
  input  wire [D_WIDTH*SIZE-1:0] input_data,
  output wire [Q_WIDTH-1   :0] output_data
);

  genvar i;

  wire [D_WIDTH-1:0] products     [SIZE-1:0];
  wire [Q_WIDTH-1:0] products_sum [SIZE-1:0];

  generate
    for(i = 0; i < SIZE; i=i+1) begin : prods
      assign products[i] = input_data[`L(D_WIDTH, i):`R(D_WIDTH, i)]
                           * COEFFICIENTS[`L(D_WIDTH, i):`R(D_WIDTH, i)];
    end
  endgenerate

  assign products_sum[0] = products[0];

  generate
    for(i = 0; i < SIZE-1; i=i+1) begin : prod_sums
      assign products_sum[i+1] = products_sum[i] + products[i+1];
    end
  endgenerate

  assign output_data = products_sum[SIZE-1];

endmodule

`endif