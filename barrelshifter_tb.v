module barrelshifter_tb; 
    wire [31:0] A, out;
    wire [4:0] shamt; 

    barrelshifter shift(out, A, shamt); 

    assign A = 15; 
    assign shamt = 0; 

    initial begin 
        #50; 
        $display("Input: %b, output: %b", A, out); 
        $finish; 
    end
endmodule