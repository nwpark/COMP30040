`timescale 1ns / 1ps

module da_test();

  `include "/home/mbyx4np3/COMP30040/COMP30040/tests/test_utils.v"

  reg [8:0] pixel_row_0;
  reg [8:0] pixel_row_1;
  reg [8:0] pixel_row_2;
  wire [9:0] output_data;

  da_unit da (.pixel_row_0(pixel_row_0),
                         .pixel_row_1(pixel_row_1),
                         .pixel_row_2(pixel_row_2),
                         .output_data(output_data));

  initial
  begin
    pixel_row_0 = 9'b001001100;
    pixel_row_1 = 9'b001001001;
    pixel_row_2 = 9'b001001001;
    #(`PERIOD);
    $stop;
  end

endmodule