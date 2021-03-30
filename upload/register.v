module register(data_out1, data_out2, clk, input_enable, output_enable1, output_enable2, reset, data_in); 
    input clk, input_enable, output_enable1, output_enable2, reset; 
    input [31:0] data_in; 
    output [31:0] data_out1, data_out2; 

    wire [31:0] dffout; 
    genvar i; 
    generate
        for (i = 0; i < 32; i = i+1) begin: loop1
            
            dffe oneBit(dffout[i], data_in[i], clk, input_enable, reset); 
        end
    endgenerate

    tristate_buffer buffer1(data_out1, dffout, output_enable1); 
    tristate_buffer buffer2(data_out2, dffout, output_enable2); 


endmodule