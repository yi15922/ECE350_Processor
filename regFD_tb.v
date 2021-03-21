module regFD_tb(); 
    reg clk, input_enable, reset; 
    wire [31:0] out_PC, out_IR; 
    reg [31:0] in_PC, in_IR; 

    regFD test(out_PC, out_IR, clk, input_enable, reset, in_PC, in_IR); 

    integer PC = 0; 
    integer IR = 100; 

    initial begin 
        //clk = 0; 
        #50; 
        input_enable = 1; 
        assign in_PC = PC;
        assign in_IR = IR;  
        clk = 1; 


        #50; 
        $display("clk: %b, inputPC: %b, inputIR: %b, outputPC: %b, outputIR: %b", clk, in_PC, in_IR, out_PC, out_IR); 

        

        $finish; 
    end

endmodule


