module regDX(out_PC, out_IR, data_out_A, data_out_B, clk, input_enable, reset, in_PC, in_IR, data_in_A, data_in_B); 
    input clk, input_enable, reset; 
    input [31:0] in_PC, in_IR, data_in_A, data_in_B; 
    output [31:0] out_PC, out_IR, data_out_A, data_out_B; 
    wire [127:0] data_in, data_out; 

    assign data_in[127:96] = in_PC; 
    assign data_in[95:64] = data_in_A; 
    assign data_in[63:32] = data_in_B; 
    assign data_in[31:0] = in_IR; 

    assign out_PC = data_out[127:96]; 
    assign data_out_A = data_out[95:64]; 
    assign data_out_B = data_out[64:32];
    assign out_IR = data_out[31:0]; 

    genvar i; 
    generate
        for (i = 0; i < 128; i = i+1) begin: loop1
            
            dffe oneBit(data_out[i], data_in[i], clk, input_enable, reset); 
        end
    endgenerate

    // initial begin
    //     #5; 
    //     $display("dataout: %d", data_out); 
    // end

endmodule