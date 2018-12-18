`ifndef CONV_DATAPATH
`define CONV_DATAPATH

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/block_ram_32.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/sobel_filter.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/gaussian_filter.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/register.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/fifo_controller.v"

module convolution_datapath (
    input  wire        clk,
    input  wire        clk_en,
    input  wire [31:0] input_data,
    output wire [31:0] output_data
  );

  //============================================================================
  // Internal signals / buses
  //============================================================================
  wire [63:0] pixel_data [2:0];

  wire [7:0] buffer_rd_addr;
  wire [7:0] buffer_wr_addr;

  wire [31:0] convolution_output;

  assign output_data[31:8] = convolution_output[23:0];

  genvar i;

  //============================================================================
  // Register to latch input data
  //============================================================================
  register #(
    .SIZE(32)
  ) input_latch (
    .clk(clk),
    .clk_en(clk_en),
    .D(input_data),
    .Q(pixel_data[2][63:32])
  );

  //============================================================================
  // Generate register for each pixel row
  //============================================================================
  generate
  for (i=0; i<3; i=i+1) begin: registers
    register #(
      .SIZE(32)
    ) pixel_reg (
      .clk(clk),
      .clk_en(clk_en),
      .D(pixel_data[i][63:32]),
      .Q(pixel_data[i][31:0])
    );
  end
  endgenerate

  //============================================================================
  // Line buffers
  //============================================================================
  fifo_controller #(
    .SIZE(`ADDRESSES_PER_ROW-1)
  ) fifo_ctrl (
    .clk(clk),
    .clk_en(clk_en),
    .rd_addr(buffer_rd_addr),
    .wr_addr(buffer_wr_addr)
  );

  generate
  for (i=0; i<2; i=i+1) begin: buffers
    block_ram_32 #(
      .SIZE(`ADDRESSES_PER_ROW-1)
    ) fifo_buffer (
      .clk     (clk),
      .clk_en  (clk_en),
      .wr_addr(buffer_wr_addr),
      .wr_data(pixel_data[i+1][31:0]),
      .rd_addr(buffer_rd_addr),
      .rd_data(pixel_data[i][63:32])
    );
  end
  endgenerate

  //============================================================================
  // Generate convolution windows
  //============================================================================
  generate
  for (i=0; i<4; i=i+1) begin: convolution
    sobel_filter conv (
      .pixel_values({pixel_data[2][23+(i*8):(i*8)],
                     pixel_data[1][23+(i*8):(i*8)],
                     pixel_data[0][23+(i*8):(i*8)]}),
      .output_data(convolution_output[7+(i*8):(i*8)])
    );
  end
  endgenerate

  //============================================================================
  // Register to delay output from 3rd convolution window
  //============================================================================
  register #(
    .SIZE(8)
  ) conv3_reg (
    .clk(clk),
    .clk_en(clk_en),
    .D(convolution_output[31:24]),
    .Q(output_data[7:0])
  );

endmodule

`endif