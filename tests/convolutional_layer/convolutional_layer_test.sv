`timescale 1ns / 1ps

module convolutional_layer_test ();

  `include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  //============================================================================
  // Test Parameters
  //============================================================================
  parameter D_WIDTH = 8;
  parameter Q_WIDTH = 16;
  parameter D_CHANNELS = 3;
  parameter Q_CHANNELS = 5;
  parameter FILTER_SIZE = 5;
  parameter IMAGE_WIDTH = 64;
  parameter IMAGE_HEIGHT = 32;
  parameter STRIDE = 1;
  parameter INDEX = 0;
  parameter FILEPATH = "/home/mbyx4np3/COMP30040/COMP30040/data/alexnet/layer_0";
  parameter total_input_pixels = IMAGE_WIDTH*IMAGE_HEIGHT;
  parameter total_output_pixels = (IMAGE_WIDTH-FILTER_SIZE+1)*(IMAGE_HEIGHT-FILTER_SIZE+1);

  //============================================================================
  // Declarations and data
  //============================================================================
  reg [D_WIDTH*D_CHANNELS-1:0] input_array [0:total_input_pixels];
  reg [Q_WIDTH*Q_CHANNELS-1:0] output_array [0:total_output_pixels];
  integer input_pixel_count = 0;
  integer output_pixel_count = 0;

  `define INPUT_DATA input_array[input_pixel_count]
  `define EXPECTED_OUTPUT_DATA output_array[output_pixel_count]

  //============================================================================
  // DUT
  //============================================================================
  reg  clk;
  reg  clk_en;
  reg  [D_CHANNELS*D_WIDTH-1:0] input_data;
  wire [Q_CHANNELS*Q_WIDTH-1:0] output_data;
  wire valid;

  convolutional_layer #(
    .D_WIDTH(D_WIDTH),
    .Q_WIDTH(Q_WIDTH),
    .D_CHANNELS(D_CHANNELS),
    .Q_CHANNELS(Q_CHANNELS),
    .FILTER_SIZE(FILTER_SIZE),
    .IMAGE_SIZE(IMAGE_WIDTH),
    .STRIDE(STRIDE),
    .FILEPATH(FILEPATH)
  ) conv_layer (
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
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/input_data.hex", input_array);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/output_data.hex", output_array);
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
