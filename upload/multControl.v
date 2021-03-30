module multControl(add, sub, shiftMultiplicand, shiftProduct, nop, ready, data_in, clock, start);
    input [2:0] data_in; 
    input clock, start; 
    output add, sub, shiftMultiplicand, shiftProduct, nop, ready; 

    wire [64:0] w_adderOut;

    wire [64:0] w_throwAway1, w_incrementResult; 
    wire w_continue, w_throwAway2, w_throwAway3, w_throwAway5, w_throwAway6, w_throwAway7; 

    adder_32 addToCountdown(w_adderOut[31:0], w_throwAway2, 32'b1, w_incrementResult[31:0], 1'b0); 
    register65 countdown(w_incrementResult, clock, !ready, start, w_adderOut); 
    assign ready = w_incrementResult[4]; 
    
    assign shiftProduct = !ready;

    assign add = !data_in[2] && (data_in[1] || data_in[0]); 
    assign sub = data_in[2] && (!data_in[1] || !data_in[0]); 
    assign shiftMultiplicand = (!data_in[2] && data_in[1] && data_in[0]) || (data_in[2] && !data_in[1] && !data_in[0]); 
    assign nop = !add && !sub;


    // always @(w_incrementResult) begin
    //     #5; 
    //     $display("counter: %d, ready: %b", w_incrementResult[31:0], ready); 
    // end

endmodule