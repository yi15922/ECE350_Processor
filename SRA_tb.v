module SRA_tb; 
    wire [31:0] A, out;
    wire [4:0] shamt; 

    SRA shift(out, A, shamt); 

    assign A = -128; 
    assign shamt = 5; 

    initial begin 
        #50; 
        $display("Input: %b, output: %b", A, out); 
        $finish; 
    end
endmodule