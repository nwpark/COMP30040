//------------------------------------------------------------------------------
//           Verilog module for convolution_FSM.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// FSM to control the convolution.
// When a request is made, the FSM will read and write to every address in the
// framestore, allowing the convolution unit to calculate the appropriate
// output data based on the input.
//------------------------------------------------------------------------------

`ifndef CONV_FSM
`define CONV_FSM

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"

// FSM states
`define IDLE 0
`define READ_DATA 1
`define WRITE_DATA 2

module convolution_FSM(
    input  wire        clk,
    input  wire        req,
    output reg         ack,
    output wire        busy,
    output reg         de_req,
    input  wire        de_ack,
    output wire [17:0] de_addr,
    output wire  [3:0] de_nbyte,
    output reg         de_rnw,
    output reg         conv_clk_en
  );

  // FSM state
  reg [1:0]  state = `IDLE;

  // Frame store read + write addresses
  reg [17:0] fs_read_addr;
  reg [17:0] fs_write_addr;
  // Column (x-coordinate) that we are currently writing to
  reg [7:0] wr_column;

  assign busy = (state != `IDLE);

  // Set output addr to either the current read or write addr
  assign de_addr = de_rnw ? fs_read_addr : fs_write_addr;

  // Output is 2 pixels narrower than original image, so we never write to
  // the leftmost or the rightmost pixel
  assign de_nbyte = wr_column == 0 ? 4'b0001
                    : wr_column == (`ADDRESSES_PER_ROW-1) ? 4'b1000
                    : 4'b0000;

  // FSM
  always @ (posedge clk)
  case (state)
    `IDLE: begin
        // Set initial state
        conv_clk_en <= 0;
        de_rnw <= 1;
        fs_read_addr <= 18'h00000;
        // Output is offset by one row, so init write addr is ADDRESSES_PER_ROW
        fs_write_addr <= `ADDRESSES_PER_ROW;
        wr_column <= 8'h00;

        if (req) begin
          // Acknowledge request + begin reading data from frame store
          ack <= 1;
          de_req <= 1;
          state <= `READ_DATA;
        end
        else begin // No request to acknowledge
          ack <= 0;
          de_req <= 0;
        end
      end
    // Read data from frame store
    `READ_DATA: begin
        // ack should be high for one clock cycle
        ack <= 0;

        if (de_ack) begin
          // Clock incoming pixel data into the convolution unit
          conv_clk_en <= 1;

          // Convolution unit only has valid output data after reading two rows
          // of pixel data from the framestore (because 3x3 filter size)
          if (fs_read_addr > (2* `ADDRESSES_PER_ROW)) begin
            // Wait a cycle for data to arrive, then write to framestore
            de_req <= 0;
            de_rnw <= 0;
            state <= `WRITE_DATA;
          end

          // Increment address for next framestore read
          fs_read_addr <= fs_read_addr + 1;

        end
        else begin
          // Only enable convolution unit when we have new data
          conv_clk_en <= 0;
        end
      end
    // Write data to frame store
    `WRITE_DATA: begin
        // Only enable convolution unit when we have new data
        conv_clk_en <= 0;

        if (!de_ack) begin
          // Write output data to framestore
          de_req <= 1;
          de_rnw <= 0;
        end
        else begin
          // Return to idle when all pixels have been read
          if (fs_read_addr > `TOTAL_ADDRESSES) begin
            de_req <= 0;
            state <= `IDLE;
          end
          else begin // Read more data from framestore
            de_rnw <= 1;
            de_req <= 1;
            state <= `READ_DATA;
          end

          // Increment address for next framestore write
          fs_write_addr <= fs_write_addr + 1;
          // Increment current x coordinate (less logic to count this on it's
          // own, rather than derive it from fs_write_addr or vice versa)
          if (wr_column == (`ADDRESSES_PER_ROW-1)) wr_column <= 8'h00;
          else wr_column <= wr_column + 1;
        end
      end
    default: begin
        state <= `IDLE;
      end
  endcase

endmodule

`endif