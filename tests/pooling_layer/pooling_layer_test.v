`timescale 1ns / 1ps

module pooling_layer_test ();

  `include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  //============================================================================
  // Test Parameters
  //============================================================================
  parameter D_WIDTH = 8;
  parameter CHANNELS = 3;
  parameter FILTER_SIZE = 2;
  parameter IMAGE_WIDTH = 64;
  parameter IMAGE_HEIGHT = 32;
  parameter total_input_pixels = IMAGE_WIDTH*IMAGE_HEIGHT;
  parameter total_output_pixels = (IMAGE_WIDTH-FILTER_SIZE+1)*(IMAGE_HEIGHT-FILTER_SIZE+1);

  //============================================================================
  // Declarations and data
  //============================================================================
  reg [D_WIDTH-1:0] c0 [0:total_input_pixels];
  reg [D_WIDTH-1:0] c1 [0:total_input_pixels];
  reg [D_WIDTH-1:0] c2 [0:total_input_pixels];
  integer input_pixel_count = 0;

  `define INPUT_DATA {c0[input_pixel_count], c1[input_pixel_count], c2[input_pixel_count]}

  reg [D_WIDTH-1:0] expected_output [0:total_output_pixels];
  integer output_pixel_count = 0;

//  `define EXPECTED_OUTPUT_DATA expected_output[output_pixel_count]

  //============================================================================
  // DUT
  //============================================================================
  reg  clk;
  reg  clk_en;
  reg  [CHANNELS*WIDTH-1:0] input_data;
  wire [CHANNELS*WIDTH-1:0] output_data;
  wire valid;

  pooling_layer #(
    .D_WIDTH(D_WIDTH),
    .CHANNELS(CHANNELS),
    .FILTER_SIZE(FILTER_SIZE),
    .IMAGE_SIZE(IMAGE_WIDTH)
  ) pool_layer (
    .clk(clk),
    .clk_en(clk_en),
    .input_data(input_data),
    .output_data(output_data),
    .valid(valid)
  );

  //============================================================================
  // Setup
  //============================================================================
  always #(`PERIOD/2) clk = ~clk;

  initial begin
    clk = 0; clk_en = 1;
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/channel_0.hex", c0);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/channel_1.hex", c1);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/channel_2.hex", c2);

    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/output_data.hex", expected_output);
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
    if (input_pixel_count > total_input_pixels) begin
      assertEquals32(output_pixel_count, total_output_pixels, "Incorrect number of pixels output");
      completeSimulation();
    end

    input_data <= `INPUT_DATA;
    input_pixel_count <= input_pixel_count + 1;
  end

  //============================================================================
  // Test
  //============================================================================
  // Check that output data is correct
  always @ (posedge clk) begin
    if (valid) begin
      assertEquals256(output_data, `EXPECTED_OUTPUT_DATA, "Incorrect ouput_data");
      output_pixel_count <= output_pixel_count + 1;
    end
  end

endmodule
