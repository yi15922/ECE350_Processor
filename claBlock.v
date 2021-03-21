module claBlock(S, Cout, G, P, A, B, Cin); 
    input [7:0] A, B; 
    input Cin; 
    output [7:0] S; 
    output Cout, G, P; 

    wire g0, g1, g2, g3, g4, g5, g6, g7; 
    wire p0, p1, p2, p3, p4, p5, p6, p7; 
    wire c1, c2, c3, c4, c5, c6, c7; 

    // Lookahead carries
    wire w_p0Cin; 
    and p0Cin(w_p0Cin, p0, Cin); 
    or g_c1(c1, g0, w_p0Cin); 

    wire w_p1c1; 
    and p1c1(w_p1c1, p1, c1); 
    or g_c2(c2, g1, w_p1c1); 

    wire w_p2c2; 
    and p2c2(w_p2c2, p2, c2); 
    or g_c3(c3, g2, w_p2c2); 

    wire w_p3c3; 
    and p3c3(w_p3c3, p3, c3); 
    or g_c4(c4, g3, w_p3c3); 

    wire w_p4c4; 
    and p4c4(w_p4c4, p4, c4); 
    or g_c5(c5, g4, w_p4c4); 

    wire w_p5c5; 
    and p5c5(w_p5c5, p5, c5); 
    or g_c6(c6, g5, w_p5c5); 

    wire w_p6c6; 
    and p6c6(w_p6c6, p6, c6); 
    or g_c7(c7, g6, w_p6c6); 



    // Full adders
    full_adder adder0(S[0], g0, p0, A[0], B[0], Cin);
    full_adder adder1(S[1], g1, p1, A[1], B[1], c1);
    full_adder adder2(S[2], g2, p2, A[2], B[2], c2);
    full_adder adder3(S[3], g3, p3, A[3], B[3], c3);
    full_adder adder4(S[4], g4, p4, A[4], B[4], c4);
    full_adder adder5(S[5], g5, p5, A[5], B[5], c5);
    full_adder adder6(S[6], g6, p6, A[6], B[6], c6);
    full_adder adder7(S[7], g7, p7, A[7], B[7], c7);

    // initial begin
    //     #50; 
    //     $display("A: %d, B: %d, S: %d", A, B, S); 

    //     $finish; 
    // end

    // Propogate bit
    and Pout(P, p0, p1, p2, p3, p4, p5, p6, p7); 
    
    wire w0, w1, w2, w3, w4, w5, w6; 
    and pandg7(w6, p7, g6); 
    and pandg6(w5, p7, p6, g5); 
    and pandg5(w4, p7, p6, p5, g4); 
    and pandg4(w3, p7, p6, p5, p4, g3); 
    and pandg3(w2, p7, p6, p5, p4, p3, g2); 
    and pandg2(w1, p7, p6, p5, p4, p3, p2, g1); 
    and pandg1(w0, p7, p6, p5, p4, p3, p2, p1, g0); 


    // Generate bit
    or Gout(G, g7, w0, w1, w2, w3, w4, w5, w6); 

    // Carry bit
    wire w_PoutCin; 
    and PoutCin(w_PoutCin, P, Cin); 

    or carryOut(Cout, w_PoutCin, G); 

endmodule