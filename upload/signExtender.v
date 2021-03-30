module signExtender(data_out, data_in); 
    input [16:0] data_in; 
    output [31:0] data_out; 

    wire w_sign;
    assign w_sign = data_in[16]; 
    wire [15:0] upperBits; 
    assign upperBits = w_sign ? 16'b1111111111111111 : 16'b0; 
    
    assign data_out[16:0] = data_in; 
    assign data_out[31:17] = upperBits; 

endmodule
