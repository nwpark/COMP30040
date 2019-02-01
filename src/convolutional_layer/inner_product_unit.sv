`ifndef INNER_PROD
`define INNER_PROD

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

module inner_product_unit #(
  parameter SIZE = -1,
  parameter I_WIDTH = -1,
  parameter O_WIDTH = -1,
  parameter FILEPATH = "",
  parameter FILEINDEX_I = -1,
  parameter FILEINDEX_J = -1
)(
  input  wire        [I_WIDTH*SIZE-1:0] input_data,
  output wire signed [O_WIDTH-1     :0] output_data
);

  string       file_i;
  string       file_j;
  reg [70*8:0] fpath;

  reg  signed [I_WIDTH-1:0] weights      [SIZE-1:0];
  wire signed [O_WIDTH-1:0] products     [SIZE-1:0];
  wire signed [O_WIDTH-1:0] products_sum [SIZE-1:0];

  genvar i;

  // Read weights from file
  initial begin
    file_i.itoa(FILEINDEX_I);
    file_j.itoa(FILEINDEX_J);
    $sformat(fpath, "%s/filter_%s_%s.hex", FILEPATH, file_i, file_j);
    $readmemh(fpath, weights);
  end

  generate
    for(i = 0; i < SIZE; i=i+1) begin : prods
      wire signed [I_WIDTH-1:0] val = input_data[I_WIDTH*i +: I_WIDTH];
//      assign products[i] = val;
      assign products[i] = val * weights[i];
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