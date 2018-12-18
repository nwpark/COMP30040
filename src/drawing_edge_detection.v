//------------------------------------------------------------------------------
//           Verilog module for drawing_edge_detection.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Top level module for edge detector.
//------------------------------------------------------------------------------

`ifndef EDGE_DETECTOR
`define EDGE_DETECTOR

`include "/home/mbyx4np3/COMP30040/COMP30040/src/convolution_datapath.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/convolution_FSM.v"

module drawing_edge_detection(
    input  wire        clk,
    input  wire        req,
    output wire        ack,
    output wire        busy,
    input  wire [15:0] r0,
    input  wire [15:0] r1,
    input  wire [15:0] r2,
    input  wire [15:0] r3,
    input  wire [15:0] r4,
    input  wire [15:0] r5,
    input  wire [15:0] r6,
    input  wire [15:0] r7,
    output wire        de_req,
    input  wire        de_ack,
    output wire [17:0] de_addr,
    output wire  [3:0] de_nbyte,
    output wire        de_rnw,
    output wire [31:0] de_w_data,
    input  wire [31:0] de_r_data
  );

  // Clock enable for convolution unit
  wire conv_clk_en;

  // Datapath
  convolution_datapath datapath(
    .clk(clk),
    .clk_en(conv_clk_en),
    .input_data(de_r_data),
    .output_data(de_w_data)
  );

  // FSM
  convolution_FSM FSM(
    .clk(clk),
    .req(req),
    .ack(ack),
    .busy(busy),
    .de_req(de_req),
    .de_ack(de_ack),
    .de_addr(de_addr),
    .de_nbyte(de_nbyte),
    .de_rnw(de_rnw),
    .conv_clk_en(conv_clk_en)
  );

endmodule

`endif