module barrelshifter65(out, A, shamt); 
    input [31:0] A; 
    input [4:0] shamt; 
    output [31:0] out; 

    

    wire [31:0] shift16, shift8, shift4, shift2, shift1; 
    wire [31:0] muxout1, muxout2, muxout3, muxout4; 

    assign shift16[31:16] = A[15:0]; 
    assign shift16[15:0] = 0; 
    twoToOneMux mux4(muxout4, shamt[4], A, shift16); 

    assign shift8[31:8] = muxout4[23:0]; 
    assign shift8[7:0] = 0; 
    twoToOneMux mux3(muxout3, shamt[3], muxout4, shift8); 

    assign shift4[31:4] = muxout3[27:0]; 
    assign shift4[3:0] = 0; 
    twoToOneMux mux2(muxout2, shamt[2], muxout3, shift4); 

    assign shift2[31:2] = muxout2[29:0]; 
    assign shift2[1:0] = 0; 
    twoToOneMux mux1(muxout1, shamt[1], muxout2, shift2); 

    assign shift1[31:1] = muxout1[30:0]; 
    assign shift1[0] = 0;
    twoToOneMux mux0(out, shamt[0], muxout1, shift1);

    

endmodule