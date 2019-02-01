`ifndef POOL_LAYER
`define POOL_LAYER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/line_buffer/line_buffer_controller.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/line_buffer/line_buffer.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/pooling_layer/max_pooling_unit.v"

module pooling_layer #(
  parameter I_WIDTH = -1,
  parameter CHANNELS = -1,
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1,
  parameter STRIDE = -1
)(
  input wire                         clk,
  input wire                         clk_en,
  input wire  [I_WIDTH*CHANNELS-1:0] input_data,
  output wire [I_WIDTH*CHANNELS-1:0] output_data,
  output wire                        valid
);

  // Internal signals / buses
  wire [I_WIDTH*(FILTER_SIZE**2)-1:0] line_buff_out [CHANNELS-1:0];

  wire [(`LOG2(IMAGE_SIZE))-1     :0] buffer_wr_addr;
  wire [(`LOG2(IMAGE_SIZE))-1     :0] buffer_rd_addr;

  genvar i;

  // Line buffer controller
  line_buffer_controller #(
    .IMAGE_SIZE(IMAGE_SIZE),
    .FILTER_SIZE(FILTER_SIZE),
    .STRIDE(STRIDE)
  ) controller (
    .clk(clk),
    .clk_en(clk_en),
    .rd_addr(buffer_rd_addr),
    .wr_addr(buffer_wr_addr),
    .valid(valid)
  );

  // Line buffer and max pooling unit for each input channel
  generate
    for (i = 0; i < CHANNELS; i = i+1) begin : pooling
      line_buffer #(
        .FILTER_SIZE(FILTER_SIZE),
        .IMAGE_SIZE(IMAGE_SIZE),
        .I_WIDTH(I_WIDTH)
      ) line_buff (
        .clk(clk),
        .clk_en(clk_en),
        .buffer_wr_addr(buffer_wr_addr),
        .buffer_rd_addr(buffer_rd_addr),
        .input_data(input_data[I_WIDTH*i +: I_WIDTH]),
        .output_data(line_buff_out[i])
      );

      max_pooling_unit #(
        .SIZE(FILTER_SIZE**2),
        .I_WIDTH(I_WIDTH)
      ) max_pool (
        .input_data(line_buff_out[i]),
        .output_data(output_data[I_WIDTH*i +: I_WIDTH])
      );
    end
  endgenerate

endmodule

`endif