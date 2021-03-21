module adder_32_tb; 
    wire [31:0] A, B; 
    wire Cin; 
    wire [31:0] S; 
    wire O; 
    adder_32 adder(S, O, A, B, Cin); 
    
    integer i; 
    assign A = i;
    integer j; 
    //inverter notB(B, j); 
    assign B = j; 
    assign Cin = 1; 

    initial begin

        // for (i = 3453453455; i < 3453453457; i = i + 1) begin
        //     #50
        //     for (j = 345345345; j < 345345347; j = j + 1) begin
        //         #50
        //         $display("A:%d, B:%d, => S:%d, O:%b", A, B, S, O); 
        //     end
        // end

        i = 1343; 
        j = 4294867295; 
        #50; 
        $display("A:%d, B:%d, => S:%d, O:%b", A, B, S, O); 

        $finish; 
    end
        


endmodule