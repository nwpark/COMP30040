//------------------------------------------------------------------------------
//           Verilog module for da_rom_3.v
//           Nick Park
//           Version 1.0
//           18th October 2018
//
// Distributed Artithmetic ROM with a 3-bit address. The ROM conforms to the
// specification described in section 1.4 of the attached report.
//
// Parameters:
// COEFFICIENT_[0-2] - DA Coefficients (4-bit signed values).
//------------------------------------------------------------------------------

(* RAM_STYLE="DISTRIBUTED" *)
module da_rom_3 #(
    parameter signed COEFFICIENT_0 = 1,
    parameter signed COEFFICIENT_1 = 1,
    parameter signed COEFFICIENT_2 = 1
  )(
    input wire        [2:0] addr,
    output reg signed [5:0] output_data
  );

  // Explicitly map addresses to ROM data (refer to section 1.4 of attached
  // report for details)
  always @ (*) begin
    case(addr)
      3'b000: output_data = 6'h00;
      3'b001: output_data = COEFFICIENT_0;
      3'b010: output_data = COEFFICIENT_1;
      3'b011: output_data = COEFFICIENT_1 + COEFFICIENT_0;
      3'b100: output_data = COEFFICIENT_2;
      3'b101: output_data = COEFFICIENT_2 + COEFFICIENT_0;
      3'b110: output_data = COEFFICIENT_2 + COEFFICIENT_1;
      3'b111: output_data = COEFFICIENT_2 + COEFFICIENT_1 + COEFFICIENT_0;
      default: output_data = 6'hXX;
    endcase
  end

endmodule