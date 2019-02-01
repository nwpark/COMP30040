`ifndef LINE_BUFFER
`define LINE_BUFFER

`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/definitions.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/block_ram.v"
`include "/home/mbyx4np3/COMP30040/COMP30040/src/common/register.v"

module line_buffer #(
  parameter FILTER_SIZE = -1,
  parameter IMAGE_SIZE = -1,
  parameter I_WIDTH = -1
)(
  input wire                                        clk,
  input wire                                        clk_en,
  input wire  [(`LOG2(IMAGE_SIZE))-1            :0] buffer_wr_addr,
  input wire  [(`LOG2(IMAGE_SIZE))-1            :0] buffer_rd_addr,
  input wire  [I_WIDTH-1                        :0] input_data,
  output wire [I_WIDTH*FILTER_SIZE*FILTER_SIZE-1:0] output_data
);

  // Internal signals / buses
  wire [I_WIDTH*FILTER_SIZE-1:0] data [FILTER_SIZE-1:0];
  genvar i, j;

  // Assign input data to input of pixel register
  assign data[FILTER_SIZE-1][I_WIDTH*(FILTER_SIZE-1) +: I_WIDTH] = input_data;

  // Registers for each row
  generate
    for (i = 0; i < FILTER_SIZE; i = i+1) begin : registers_i
      for (j = 0; j < FILTER_SIZE-1; j = j+1) begin : registers_j
        register #(
          .WIDTH(I_WIDTH)
        ) pixel_reg (
          .clk(clk),
          .clk_en(clk_en),
          .D(data[i][I_WIDTH*(j+1) +: I_WIDTH]),
          .Q(data[i][I_WIDTH*(j)   +: I_WIDTH])
        );
      end
    end
  endgenerate

  // Line buffer for each row
  generate
    for (i = 0; i < FILTER_SIZE-1; i = i+1) begin : buffers
      block_ram #(
        .WIDTH(I_WIDTH),
        .DEPTH(IMAGE_SIZE-(FILTER_SIZE-1))
      ) line_buffer (
        .clk(clk),
        .clk_en(clk_en),
        .wr_addr(buffer_wr_addr),
        .wr_data(data[i+1][I_WIDTH-1:0]),
        .rd_addr(buffer_rd_addr),
        .rd_data(data[i][I_WIDTH*(FILTER_SIZE-1) +: I_WIDTH])
      );
    end
  endgenerate

  // Assign output data
  generate
    for (i = 0; i < FILTER_SIZE; i = i+1) begin : out_data
      assign output_data[FILTER_SIZE*I_WIDTH*i +: FILTER_SIZE*I_WIDTH] = data[i];
    end
  endgenerate

endmodule

`endif