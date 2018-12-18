`timescale 1ns / 1ps

module pixel_buffer_test ();

  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  //============================================================================
  // Declarations
  //============================================================================
  reg clk;
  reg clk_en;
  reg [19:0] input_data;
  reg output_data;

  parameter total_input_pixels = 2048;
  reg [19:0] image_data [0:total_input_pixels];
  integer input_pixel_count = 0;

  `define INPUT_DATA \
    {image_data[input_pixel_count+3], \
     image_data[input_pixel_count+2], \
     image_data[input_pixel_count+1], \
     image_data[input_pixel_count]}

    //============================================================================
    // DUT
    //============================================================================
  pixel_buffer #(
    .FILTER(2),
    .INPUT_WIDTH(64)
  ) pixel_buff (
    .clk(clk),
    .clk_en(clk_en),
    .input_data(input_data),
    .output_data(output_data)
  );

    //============================================================================
    // Setup
    //============================================================================
  always #(`PERIOD/2) clk = ~clk;

  initial begin
    clk = 1; clk_en = 1;

    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/input_data.hex",
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
    //assertEquals32(de_w_data & `DATA_MASK, `EXPECTED_OUTPUT_DATA & `DATA_MASK,
    //  "Incorrect de_w_data");
  end

endmodule
