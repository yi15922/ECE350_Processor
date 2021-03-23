module regMW_tb(); 
    reg clk, input_enable, reset; 
    wire [31:0] out_IR, data_out_O, data_out_D; 
    reg [31:0] in_IR, data_in_O, data_in_D; 

    regMW test(out_IR, data_out_O, data_out_D, clk, input_enable, reset, in_IR, data_in_O, data_in_D); 

    integer IR = 100; 
    integer O = 34;
    integer D = -1; 

    initial begin 
        //clk = 0; 
        #50; 
        input_enable = 1; 
        assign in_IR = IR;  
        assign data_in_O = O; 
        assign data_in_D = D; 
        clk = 1; 


        #50; 
        $display("clk: %b, inputIR: %b, inputO: %d, inputD: %d \t outputIR: %b, outputO: %d, outputD: %d", clk, in_IR, data_in_O, data_in_D, out_IR, data_out_O, data_out_D); 

        

        $finish; 
    end

endmodule


