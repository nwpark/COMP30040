//------------------------------------------------------------------------------
//           Test Utilities
//           Nick Park
//           Version 1.0
//           6th October 2018
//
// Last modified: 7/10/18 (NP)
//------------------------------------------------------------------------------

`ifndef TEST_UTILS
`define TEST_UTILS

`define PERIOD 40				// 25MHz freq

// Signal to indicate when an error occurred - viewable on waveform
reg error = 0;

//==============================================================================
// Assertion tasks
//==============================================================================

// Assert that the given value is equal to the expected value
task assertEquals(input actual, input expected, input [0:300] message);
begin
  if (actual !== expected) begin
    $display("Assertion Error at time %t", $time);
    $display("%s", message);
    $display("Expected value of %x, but actual value was %x.", expected,actual);
    error = 1;
    #(`PERIOD*10);
    $stop;
  end
end
endtask

// Assert that the given value is equal to the expected value
task assertEquals32(input [31:0] actual,
                    input [31:0] expected,
                    input [0:300] message);
begin
  if (actual !== expected) begin
    $display("Assertion Error at time %t", $time);
    $display("%s", message);
    $display("Expected value of %x, but actual value was %x.", expected,actual);
    error = 1;
    #(`PERIOD*10);
    $stop;
  end
end
endtask

// Assert that the given value is high
task assertTrue(input val, input [0:300] message);
  assertEquals(val, 1, message);
endtask

// Assert that the given value is low
task assertFalse(input val, input [0:300] message);
  assertEquals(val, 0, message);
endtask

//==============================================================================
// Utility tasks
//==============================================================================

// Stop the simulation
task completeSimulation;
begin
  if (!error) $display("Simulation completed with no errors.");
  else $display("Simulation completed with errors, check log for details.");

  $stop;
end
endtask

`endif