module signExtender(data_out, data_in); 
    input [16:0] data_in; 
    output [31:0] data_out; 

    wire sign = data_in[16]; 
    wire [15:0] upperBits; 
    assign upperBits = sign ? 16'd-1 : 16'd0; 
    
    assign data_out[16:0] = data_in; 
    assign data_out[31:17] = upperBits; 

endmodule; 
