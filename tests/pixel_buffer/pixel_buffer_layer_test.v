`timescale 1ns / 1ps

module pixel_buffer_layer_test ();

  `include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  //============================================================================
  // Declarations
  //============================================================================
  parameter DEPTH = 1;
  parameter FILTER_SIZE = 2;
  parameter IMAGE_SIZE = 64;

  reg clk;
  reg clk_en;
  reg [(`BITS-1):0] input_data;
  wire [(`BITS-1):0] output_data;
  wire valid;

  parameter total_input_pixels = 2048;
  reg [(`BITS-1):0] image_data [0:total_input_pixels];
  integer input_pixel_count = 0;

  `define INPUT_DATA image_data[input_pixel_count]

  //============================================================================
  // DUT
  //============================================================================

  // Internal signals / buses
  wire [(`BITS*FILTER_SIZE*FILTER_SIZE-1):0] pixel_buff_out [(DEPTH-1):0];

  wire [(`LOG2(IMAGE_SIZE))-1:0] buffer_wr_addr;
  wire [(`LOG2(IMAGE_SIZE))-1:0] buffer_rd_addr;

  genvar i;

  // Pixel buffer controller
  pixel_buffer_controller #(
    .IMAGE_SIZE(IMAGE_SIZE),
    .FILTER_SIZE(FILTER_SIZE)
  ) controller (
    .clk(clk),
    .clk_en(clk_en),
    .rd_addr(buffer_rd_addr),
    .wr_addr(buffer_wr_addr),
    .valid(valid)
  );

  // Pixel buffer for each kernel
  generate
    for (i = 0; i < DEPTH; i = i+1) begin : registers
      pixel_buffer #(
        .FILTER_SIZE(FILTER_SIZE),
        .IMAGE_SIZE(IMAGE_SIZE)
      ) pixel_buff (
        .clk(clk),
        .clk_en(clk_en),
        .buffer_wr_addr(buffer_wr_addr),
        .buffer_rd_addr(buffer_rd_addr),
        .input_data(input_data[`L(`BITS, i):`R(`BITS, i)]),
        .output_data(pixel_buff_out[i])
      );
    end
  endgenerate

  //============================================================================
  // Setup
  //============================================================================
  always #(`PERIOD/2) clk = ~clk;

  initial begin
    clk = 1; clk_en = 1;

    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/pixel_buffer/input_data.hex",
              image_data);
  end

  initial begin
    #(`PERIOD*200000)
      $display("Simulation timed out.");
    $stop;
  end

  //============================================================================
  // FSM to Test the Unit
  //============================================================================
  always @ (posedge clk) begin
    input_data <= `INPUT_DATA;
    input_pixel_count = input_pixel_count + 1;
  end

  //============================================================================
  // Test
  //============================================================================
  // Check that output data + addr + nbyte are correct
  always @ (posedge clk) begin
      // Only need to verify data for the pixels we are currently writing
//      assertEquals32(de_w_data & `DATA_MASK, `EXPECTED_OUTPUT_DATA & `DATA_MASK,
//        "Incorrect de_w_data");
    assertEquals32(pixel_buff_out, "Incorrect pixel_buff_out");
  end

endmodule
