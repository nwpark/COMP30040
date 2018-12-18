//------------------------------------------------------------------------------
//           Verilog module for drawing_edge_detection_test.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Test bench for drawing_edge_detection.v
//------------------------------------------------------------------------------

`timescale 1ns / 1ps

module drawing_edge_detection_test ();

  //============================================================================
  // Include utility files
  //============================================================================
  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  //============================================================================
  // Declarations
  //============================================================================
  // FSM states
  `define INITIALIZE 0
  `define IDLE 1
  `define MAKE_REQUEST 2
  `define HANDLE_ACK 3
  `define VERIFY_DATA 4
  integer state = `INITIALIZE;

  // Signals + data for DUT
  reg         clk;
  reg         req;
  wire        ack;
  wire        busy;
  wire        de_req;
  reg         de_ack;
  wire [17:0] de_addr;
  wire  [3:0] de_nbyte;
  wire        de_rnw;
  wire [31:0] de_w_data;
  reg  [31:0] de_r_data;

  // Total number of test cases
  parameter number_of_test_cases = 2;
  // Reference to the current test case
  integer current_test_case = 0;

  // Total number of pixels in input image
  parameter total_input_pixels = 307200;
  // Expected number of output pixels
  parameter total_output_pixels = 305920;
  // Clock cycles to wait before acknowledging output requests
  integer ack_delay = 0;

  // Holds input data in the form of a pixel array
  reg [7:0] image_data [0:total_input_pixels];
  // Holds expected output data
  reg [7:0] expected_output_data [0:total_output_pixels];
  // Holds expected output nbyte values
  reg [3:0] expected_nbyte [0:total_output_pixels];
  // Holds expected output addresses
  reg [17:0] expected_addr [0:total_output_pixels];

  // Number of pixels input so far for the current test case
  integer input_pixel_count = 0;
  // Number of pixels output so far for the current test case
  integer output_pixel_count = 0;

  // Count the clock cycles
  integer total_clock_count = 0;
  // Clock cycle count at the start of each test case
  integer initial_clock_count = 0;
  // Clock cycle count for the current test case
  `define CURRENT_CLOCK_COUNT total_clock_count - initial_clock_count

  // Given intput data for current pixel for the current test case.
  `define INPUT_DATA \
    {image_data[input_pixel_count+3], \
     image_data[input_pixel_count+2], \
     image_data[input_pixel_count+1], \
     image_data[input_pixel_count]}

  // Expected output data for current pixel for the current test case.
  `define EXPECTED_OUTPUT_DATA \
    {expected_output_data[output_pixel_count+3], \
     expected_output_data[output_pixel_count+2], \
     expected_output_data[output_pixel_count+1], \
     expected_output_data[output_pixel_count]}

  // Expected nbyte for the current pixel for the current test case.
  `define EXPECTED_OUTPUT_NBYTE \
    expected_nbyte[output_pixel_count/4]

  // Expected addr for the current pixel for the current test case.
  `define EXPECTED_OUTPUT_ADDR \
    expected_addr[output_pixel_count/4]

  // Data mask - to mask output data, leaving us with only the bits used for
  // the pixels we are currently writing to.
  `define DATA_MASK \
    {{8{!`EXPECTED_OUTPUT_NBYTE[3]}}, {8{!`EXPECTED_OUTPUT_NBYTE[2]}}, \
     {8{!`EXPECTED_OUTPUT_NBYTE[1]}}, {8{!`EXPECTED_OUTPUT_NBYTE[0]}}}

  //============================================================================
  // Instantiate DUT
  //============================================================================
  drawing_edge_detection edge_detector (
    .clk(clk),
    .req(req),
    .ack(ack),
    .busy(busy),
    .de_req(de_req),
    .de_ack(de_ack),
    .de_addr(de_addr),
    .de_nbyte(de_nbyte),
    .de_rnw(de_rnw),
    .de_w_data(de_w_data),
    .de_r_data(de_r_data)
  );

  //============================================================================
  // Setup
  //============================================================================
  // Oscillate clock
  always #(`PERIOD/2) clk = ~clk;

  // Count clock cycles
  always @ (posedge clk)
  begin
    total_clock_count <= total_clock_count + 1;
  end

  // Limit simulation run time - allows us to see if unit stays busy forever
  initial begin
    #(`PERIOD*2000000)
    $display("Simulation timed out.");
    $stop;
  end

  // Set initial data values
  initial
  begin
    // Initialize control signals
    req = 0; clk = 1; de_ack = 0;

    // Load test data
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/testdata/input_data.hex",
              image_data);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/testdata/expected_output_data.hex",
              expected_output_data);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/testdata/expected_nbyte.hex",
              expected_nbyte);
    $readmemh("/home/mbyx4np3/COMP30040/COMP30040/tests/testdata/expected_addr.hex",
              expected_addr);
  end

  //============================================================================
  // FSM to Test the Unit
  //============================================================================
  always @ (posedge clk)
  case (state)
    `INITIALIZE: begin
        // Reset values ready for next test
        initial_clock_count <= total_clock_count;
        input_pixel_count <= 0;
        output_pixel_count <= 0;
        state <= `IDLE;
      end
    // Do nothing for a few cycles to verify the unit remains idle
    `IDLE:
      if (`CURRENT_CLOCK_COUNT == 20) state <= `MAKE_REQUEST;
    // Request unit to perform edge detection
    `MAKE_REQUEST: begin
        // Verify unit is idle, then make a request
        assertFalse(busy, "Unit should have been idle");
        req <= 1;
        state <= `HANDLE_ACK;
      end
    `HANDLE_ACK: begin
        // Wait for unit to acknowledge request (or simulation to time out)
        if (ack) begin
          req <= 0;
          state <= `VERIFY_DATA;
        end
      end
    `VERIFY_DATA: begin
        // Wait for unit to finish drawing (or simulation to time out)
        if (!busy) begin
          // Verify that the correct number of pixels were drawn
          assertEquals32(output_pixel_count, total_output_pixels,
                         "Incorrect number of pixels requested");

          // Tests are complete after {number_of_test_cases} lines are drawn
          if (current_test_case == number_of_test_cases - 1) begin
            completeSimulation();
          end

          // Move on to the next test case
          current_test_case <= current_test_case + 1;
          state <= `INITIALIZE;
        end
      end
    default: state <= `INITIALIZE;
  endcase

  //============================================================================
  // Always blocks to respond to output signals on every clock posedge
  //============================================================================
  // Acknowledge drawing engine requests
  always @ (posedge clk)
  begin
    if (de_req && !de_ack)
    begin
      if (ack_delay > 0) begin
        ack_delay <= ack_delay - 1; // Reduce remaining ack delay
      end
      else begin
        // Acknowledge request
        de_ack <= 1;
        #(`PERIOD)
        de_ack <= 0;

        if (de_rnw) begin
          // If request is to read frame store, then provide the data
          de_r_data <= `INPUT_DATA;
          input_pixel_count <= input_pixel_count + 4;
        end
        else begin
          output_pixel_count <= output_pixel_count + 4;
        end

        // Set a random delay for acknowledging the next request
        ack_delay <= $urandom % 5;
      end
    end
    else de_ack <= 0;
  end

  //============================================================================
  // Always blocks to monitor output signals on every clock posedge
  //============================================================================
  // If de_req is high, check that other signals are in a legal state
  always @ (posedge clk)
  begin
    // Check that unit does not make requests when idle
    if (de_req) assertTrue(busy, "de_req went high when unit was idle");
  end

  // If ack is high, check that other signals are in a legal state
  always @ (posedge clk)
  begin
    if (ack) begin
      // Check that ack is only set high when we have made a request
      assertTrue(req, "ack went high without making a request");
      // Check that unit became busy after acknowledging an input reqeuest
      assertTrue(busy, "ack went high but unit remained idle");
    end
  end

  // Check that output data + addr + nbyte are correct
  always @ (posedge clk)
  begin
    if (de_req && !de_rnw) begin
      // Only need to verify data for the pixels we are currently writing
      assertEquals32(de_w_data & `DATA_MASK, `EXPECTED_OUTPUT_DATA & `DATA_MASK,
                     "Incorrect de_w_data");
      assertEquals32(de_addr, `EXPECTED_OUTPUT_ADDR, "Incorrect de_addr");
      assertEquals32(de_nbyte, `EXPECTED_OUTPUT_NBYTE, "Incorrect de_nbyte");
    end
  end

endmodule
