module SRA(out, A, shamt); 
    input [31:0] A; 
    input [4:0] shamt; 
    output [31:0] out; 

    wire [31:0] shift16, shift8, shift4, shift2, shift1; 
    wire [31:0] muxout1, muxout2, muxout3, muxout4; 
    wire [31:0] sign; 

    assign sign = A[31] ? -1 : 0; 

    assign shift16[15:0] = A[31:16]; 
    assign shift16[31:16] = sign; 
    twoToOneMux mux4(muxout4, shamt[4], A, shift16); 

    assign shift8[23:0] = muxout4[31:8]; 
    assign shift8[31:24] = sign; 
    twoToOneMux mux3(muxout3, shamt[3], muxout4, shift8); 

    assign shift4[27:0] = muxout3[31:4]; 
    assign shift4[31:28] = sign; 
    twoToOneMux mux2(muxout2, shamt[2], muxout3, shift4); 

    assign shift2[29:0] = muxout2[31:2]; 
    assign shift2[31:30] = sign; 
    twoToOneMux mux1(muxout1, shamt[1], muxout2, shift2); 

    assign shift1[30:0] = muxout1[31:1]; 
    assign shift1[31] = sign; 
    twoToOneMux mux0(out, shamt[0], muxout1, shift1); 

    initial begin 
        #50; 
        $display("Sign: %b", sign); 
        $finish; 
    end

endmodule
