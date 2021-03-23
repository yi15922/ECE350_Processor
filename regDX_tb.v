module regDX_tb(); 
    reg clk, input_enable, reset; 
    wire [31:0] out_PC, out_IR, data_out_A, data_out_B; 
    reg [31:0] in_PC, in_IR, data_in_A, data_in_B; 

    regDX test(out_PC, out_IR, data_out_A, data_out_B, clk, input_enable, reset, in_PC, in_IR, data_in_A, data_in_B); 

    integer PC = 0; 
    integer IR = 100; 
    integer A = 34;
    integer B = -1; 

    initial begin 
        //clk = 0; 
        #50; 
        input_enable = 1; 
        assign in_PC = PC;
        assign in_IR = IR;  
        assign data_in_A = A; 
        assign data_in_B = B; 
        clk = 1; 


        #50; 
        $display("clk: %b, inputPC: %b, inputIR: %b, inputA: %d, inputB: %d \t outputPC: %b, outputIR: %b, outputA: %d, outputB: %d", clk, in_PC, in_IR, data_in_A, data_in_B, out_PC, out_IR, data_out_A, data_out_B); 

        

        $finish; 
    end

endmodule


