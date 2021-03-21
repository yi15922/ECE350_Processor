module claBlock_tb; 
    wire [7:0] A, B; 
    reg Cin; 
    wire [7:0] S; 
    wire Cout, G, P; 
    claBlock lookaheadAdder(S, Cout, G, P, A, B, Cin); 
    
    integer i; 
    assign A = i;
    integer j; 
    assign B = j; 

    initial begin
        Cin = 0; 

        // for (i = 200; i < 255; i = i + 1) begin
        //     #20
        //     for (j = 0; j < 8; j = j + 1) begin
        //         #20
        //         $display("A:%d, B:%d, Cin:%b => S:%d, Cout:%b, generate: %b, propagate: %b", A, B, Cin, S, Cout, G, P); 
        //     end
        // end

        i = 15; 
        j = -15; 
        #50; 
        $display("A:%d, B:%d, Cin:%b => S:%d, Cout:%b, generate: %b, propagate: %b", A, B, Cin, S, Cout, G, P); 

        $finish; 
    end
        


endmodule