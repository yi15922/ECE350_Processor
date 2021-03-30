module tristate_buffer65(out, in, enable); 
    input [64:0] in;
    input enable; 
    output [64:0] out; 

    assign out = enable ? in : 65'bz; 

endmodule