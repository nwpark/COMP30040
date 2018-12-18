//`timescale 1ns / 1ps

////`ifndef TEST_UTILS
////  `include "/home/mbyx4np3/COMP32211/phase1/test_utils.v"
////`endif

//`define PERIOD 40

//module convolver_test();
//    reg error = 0;

//    task assertEquals32(input [31:0] actual,
//                        input [31:0] expected,
//                        input [0:300] message);
//    begin
//      if (actual != expected)
//        begin
//        error = 1;
//        $display("Assertion Error at time %t", $time);
//        $display("%s", message);
//        $display("Expected value of %x, but actual value was %x.", expected,actual);
//        #(`PERIOD*10);
//        $stop;
//        end
//    end
//    endtask

//    //==============================================================================
//    reg clk;
//    reg clk_en;
//    reg [7:0] test_data [0:307200];
//    reg [7:0] expected_data [0:307200];
    
//    always #(`PERIOD/2) clk = ~clk;
    
//    initial
//    begin
//        clk = 0;
//        clk_en = 1;
//        $readmemh("/home/mbyx4np3/COMP32211/phase2/testdata/test_image.hex", test_data);
//        $readmemh("/home/mbyx4np3/COMP32211/phase2/testdata/test_image_conv.hex", expected_data);
//    end
    
//    //==============================================================================
//    reg [31:0] input_data;
//    wire [31:0] output_data;
    
//    convolver3x3 conv (.clk(clk),
//                  .clk_en(clk_en),
//                  .input_data(input_data),
//                  .output_data(output_data));
                  
//    //==============================================================================
//    integer row = 0;
//    integer address = 0;
    
//    integer test_data_address = 0;
//    integer count = 0;
//    integer output_count = 0;
    
//    initial
//    begin
//        for (address = 0; address <= 1280; address = address + 4)
//        begin
//            input_data = {test_data[test_data_address+3], test_data[test_data_address+2], test_data[test_data_address+1], test_data[test_data_address]};
//            #(`PERIOD);
            
//            test_data_address = test_data_address + 4;
//        end
        
//        for (row = 0; row < 480; row = row + 1)
//        begin
//            for (address = 0; address < 636; address = address + 4)
//            begin
//                input_data = {test_data[test_data_address+3], test_data[test_data_address+2], test_data[test_data_address+1], test_data[test_data_address]};

//                #(`PERIOD);
                
//                assertEquals32(output_data, {expected_data[output_count+3], expected_data[output_count+2], expected_data[output_count+1], expected_data[output_count]}, "Incorrect de_addr");
//                test_data_address = test_data_address + 4;
//                output_count = output_count + 4;
//            end
//            input_data = {test_data[test_data_address+3], test_data[test_data_address+2], test_data[test_data_address+1], test_data[test_data_address]};
//            #(`PERIOD);
//            assertEquals32(output_data, {8'hXX, 8'hXX, expected_data[output_count+1], expected_data[output_count]}, "Incorrect de_addr");
//            test_data_address = test_data_address + 4;
//            output_count = output_count + 2;
//        end
//        $stop;
//    end
                         
//endmodule
