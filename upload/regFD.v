module regFD(out_PC, out_IR, clk, input_enable, reset, in_PC, in_IR); 
    input clk, input_enable, reset; 
    input [31:0] in_PC, in_IR; 
    output [31:0] out_PC, out_IR; 
    wire [63:0] data_in, data_out; 

    assign data_in[63:32] = in_PC; 
    assign data_in[31:0] = in_IR; 
    assign out_PC = data_out[63:32]; 
    assign out_IR = data_out[31:0]; 

    genvar i; 
    generate
        for (i = 0; i < 64; i = i+1) begin: loop1
            
            dffe oneBit(data_out[i], data_in[i], clk, input_enable, reset); 
        end
    endgenerate

    // initial begin
    //     #5; 
    //     $display("dataout: %d", data_out); 
    // end

endmodule