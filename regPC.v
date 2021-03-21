module regPC(data_out, clk, input_enable, reset, data_in); 
    input clk, input_enable, reset; 
    input [31:0] data_in; 
    output [31:0] data_out; 

    genvar i; 
    generate
        for (i = 0; i < 32; i = i+1) begin: loop1
            
            dffe oneBit(data_out[i], data_in[i], clk, input_enable, reset); 
        end
    endgenerate

    // initial begin
    //     #5; 
    //     $display("dataout: %d", data_out); 
    // end

endmodule