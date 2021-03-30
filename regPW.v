module regPW(out_IR, data_out_P, clk, input_enable, reset, in_IR, data_in_P); 
    input clk, input_enable, reset; 
    input [31:0] in_IR, data_in_P; 
    output [31:0] out_PC, out_IR, data_out_P; 
    wire [63:0] data_in, data_out; 

    assign data_in[63:32] = data_in_P; 
    assign data_in[31:0] = in_IR; 

    assign data_out_P = data_out[63:32];
    assign out_IR = data_out[31:0]; 

    genvar i; 
    generate
        for (i = 0; i < 64; i = i+1) begin: loop1
            
            dffe oneBit(data_out[i], data_in[i], clk, input_enable, reset); 
        end
    endgenerate

    // always @(posedge clk) begin
    //     #5; 
    //     $display("MW Register O: %d", data_out_O); 
    // end

endmodule