module full_adder_tb; 
    reg A, B, Cin; 
    wire S, Cout, G, P; 
    full_adder adder(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout), .G(G), .P(P)); 

    initial begin
        $dumpfile("full_adder_wave.vcd"); 
        $dumpvars(0, full_adder_tb); 
    end
    
    initial begin
        A = 0; 
        B = 0; 
        Cin = 0; 
        #80;
        $finish; 
    end

    

    always
        #10 A = ~A; 
    always
        #20 B = ~B; 
    always
        #40 Cin = ~Cin; 

    always @(A, B, Cin) begin
        #1; 
        $display("A:%b, B:%b, Cin:%b => S:%b, Cout:%b, generate: %b, propagate: %b", A, B, Cin, S, Cout, G, P); 
    end

        


endmodule