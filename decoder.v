module decoder(out, select); 
    input [4:0] select; 
    output [31:0] out; 

    barrelshifter shifter(out, 1, select); 

endmodule