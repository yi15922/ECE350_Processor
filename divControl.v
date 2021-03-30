module divControl(add, shiftQuotient, ready, Q0, MSB, clock, start); 
    input MSB, clock, start; 
    output add, shiftQuotient, ready, Q0; 

    wire [64:0] w_incrementResult; 
    wire w_writeEnable; 
    wire [64:0] w_adderOut; 
    wire throwAway1; 

    adder_32 increment(w_adderOut[31:0], throwAway1, 32'b1, w_incrementResult[31:0], 1'b0); 
    register65 incrementRegister(w_incrementResult, clock, !ready, start, w_adderOut); 
    assign ready = w_incrementResult[5] && w_incrementResult[0]; 

    // always @(w_incrementResult) begin
    //     #5; 
    //     $display("counter: %d, ready: %b, msb: %d, add: %b, Q0: %b", w_incrementResult[31:0], ready, MSB, add, Q0); 
    // end

    assign Q0 = !MSB; 
    assign add = MSB; 
    assign shiftQuotient = !ready;


endmodule