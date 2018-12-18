`timescale 1ns / 1ps

module convolutional_layer_test ();

  `include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  //============================================================================
  // Test Parameters
  //============================================================================
  parameter D_WIDTH = 8;
  parameter Q_WIDTH = 16;
  parameter D_CHANNELS = 2;
  parameter Q_CHANNELS = 2;
  parameter total_input_pixels = 2048;

  //============================================================================
  // Declarations and data
  //============================================================================
  reg [D_WIDTH-1:0] c0 [0:total_input_pixels];
  reg [D_WIDTH-1:0] c1 [0:total_input_pixels];

  integer input_pixel_count = 0;

  `define INPUT_DATA {c0[input_pixel_count],c1[input_pixel_count]}
  `define EXPECTED_OUTPUT_DATA \
    {(c0[input_pixel_count-1] + c0[input_pixel_count-2] + c0[input_pixel_count-65] + c0[input_pixel_count-66] \
      + c1[input_pixel_count-1] + c1[input_pixel_count-2] + c1[input_pixel_count-65] + c1[input_pixel_count-66]), \
     (c0[input_pixel_count-1] + c0[input_pixel_count-2] + c0[input_pixel_count-65] + c0[input_pixel_count-66] \
      + c1[input_pixel_count-1] + c1[input_pixel_count-2] + c1[input_pixel_count-65] + c1[input_pixel_count-66])}

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
    .FILTER_SIZE(2),
    .IMAGE_SIZE(64)
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
    clk = 1; clk_en = 1;
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/channel_0.hex", c0);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/convolutional_layer/channel_1.hex", c1);
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
    if (input_pixel_count == total_input_pixels) begin
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
    if (input_pixel_count > 65)
      assertEquals32(output_data, `EXPECTED_OUTPUT_DATA, "Incorrect ouput_data");
  end

endmodule
