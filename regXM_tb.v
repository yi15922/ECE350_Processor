module regXM_tb(); 
    reg clk, input_enable, reset; 
    wire [31:0] out_IR, data_out_O, data_out_B; 
    reg [31:0] in_IR, data_in_O, data_in_B; 

    regXM test(out_IR, data_out_O, data_out_B, clk, input_enable, reset, in_IR, data_in_O, data_in_B); 

    integer IR = 100; 
    integer O = 34;
    integer B = -1; 

    initial begin 
        //clk = 0; 
        #50; 
        input_enable = 1; 
        assign in_IR = IR;  
        assign data_in_O = O; 
        assign data_in_B = B; 
        clk = 1; 


        #50; 
        $display("clk: %b, inputIR: %b, inputO: %d, inputB: %d \t outputIR: %b, outputO: %d, outputB: %d", clk, in_IR, data_in_O, data_in_B, out_IR, data_out_O, data_out_B); 

        

        $finish; 
    end

endmodule


