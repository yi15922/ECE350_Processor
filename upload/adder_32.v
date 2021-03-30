module adder_32(S, O, A, B, Cin); 
    input [31:0] A, B; 
    input Cin; 
    output [31:0] S; 
    output O; 

    wire c8, c16, c24, c31; 
    wire G0, G1, G2, G3; 
    wire P0, P1, P2, P3; 

    // Adder chain
    claBlock claBlock0(S[7:0], c8, G0, P0, A[7:0], B[7:0], Cin); 
    claBlock claBlock1(S[15:8], c16, G1, P1, A[15:8], B[15:8], c8); 
    claBlock claBlock2(S[23:16], c24, G2, P2, A[23:16], B[23:16], c16); 
    claBlock claBlock3(S[31:24], c31, G3, P3, A[31:24], B[31:24], c24); 

    // initial begin
    //     #50; 
    //     $display("c8: %b", c8); 

    //     $finish; 
    // end

    // Overflow detection
    wire o1, o2; 
    wire w_negativeS, w_negativeA, w_negativeB; 
    not negativeS(w_negativeS, S[31]); 
    not negativeA(w_negativeA, A[31]); 
    not negativeB(w_negativeB, B[31]); 
    and overflow1(o1, A[31], B[31], w_negativeS); 
    and overflow2(o2, w_negativeA, w_negativeB, S[31]); 
    or overflow(O, o1, o2); 

endmodule 