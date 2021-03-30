module full_adder(S, G, P, A, B, Cin);
    input A, B, Cin;
    output S, G, P; 
    wire w1, w2, w3; 


    and A_and_B(w1, A, B); 
    or AorB(w2, A, B); 

    xor sumResult(S, A, B, Cin); 
    assign P = w2; 
    assign G = w1;



    // initial begin
    //     #50; 
    //     $display("A: %b, B: %b, Cin: %b, Result: %b", A, B, Cin, S); 

    //     $finish; 
    // end

endmodule