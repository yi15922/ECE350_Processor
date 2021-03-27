module regXM(out_IR, data_out_O, data_out_B, clk, input_enable, reset, in_IR, data_in_O, data_in_B); 
    input clk, input_enable, reset; 
    input [31:0] in_IR, data_in_O, data_in_B; 
    output [31:0] out_PC, out_IR, data_out_O, data_out_B; 
    wire [95:0] data_in, data_out; 

    assign data_in[95:64] = data_in_O; 
    assign data_in[63:32] = data_in_B; 
    assign data_in[31:0] = in_IR; 

    assign data_out_O = data_out[95:64]; 
    assign data_out_B = data_out[63:32];
    assign out_IR = data_out[31:0]; 

    genvar i; 
    generate
        for (i = 0; i < 96; i = i+1) begin: loop1
            
            dffe oneBit(data_out[i], data_in[i], clk, input_enable, reset); 
        end
    endgenerate

    // always @(posedge clk) begin
    //     #5; 
    //     $display("XM Register B: %d", data_out_B); 
    // end

endmodule