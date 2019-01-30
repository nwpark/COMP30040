`timescale 1ns / 1ps

module relu_layer_test ();

  `include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  //============================================================================
  // Test Parameters
  //============================================================================
  parameter D_WIDTH = 8;
  parameter CHANNELS = 3;
  parameter total_pixels = 2048;

  //============================================================================
  // Declarations and data
  //============================================================================
  reg [D_WIDTH*CHANNELS-1:0] input_array [0:total_pixels];
  reg [D_WIDTH*CHANNELS-1:0] output_array [0:total_pixels];
  integer pixel_count = 0;

  `define INPUT_DATA input_array[pixel_count]
  `define EXPECTED_OUTPUT_DATA output_array[pixel_count]

  //============================================================================
  // DUT
  //============================================================================
  reg  clk;
  wire [D_WIDTH*CHANNELS-1:0] input_data;
  wire [D_WIDTH*CHANNELS-1:0] output_data;

  assign input_data = `INPUT_DATA;

  relu_layer #(
    .D_WIDTH(D_WIDTH),
    .CHANNELS(CHANNELS)
  ) relu_layer (
    .input_data(input_data),
    .output_data(output_data)
  );

  //============================================================================
  // Setup
  //============================================================================
  always #(`PERIOD/2) clk = ~clk;

  initial begin
    clk = 0;
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/relu_layer/input_data.hex", input_array);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/relu_layer/output_data.hex", output_array);
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
    if (pixel_count > total_pixels) begin
      completeSimulation();
    end

    pixel_count <= pixel_count + 1;
  end

  //============================================================================
  // Test
  //============================================================================
  // Check that output data is correct
  always @ (posedge clk) begin
    assertEquals256(output_data, `EXPECTED_OUTPUT_DATA, "Incorrect output_data");
  end

endmodule
