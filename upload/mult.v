module mult(data_operandA, data_operandB, ctrl_MULT, 
            clock, data_result, data_exception, data_resultRDY); 

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire [2:0] data_in; 
    wire add, sub, shiftMultiplicand, shiftProduct, nop; 
    wire [4:0] aluOp; 
    assign aluOp[4:1] = 4'd0; 
    wire [64:0] runningProduct, regInput; 
    assign data_in = runningProduct[2:0]; 

    assign aluOp[0] = !add && sub; 

    multControl multiplicationController(add, sub, shiftMultiplicand, shiftProduct, nop, data_resultRDY, data_in, clock, ctrl_MULT);

    wire [31:0] multiplicand;
    assign multiplicand = shiftMultiplicand ? data_operandA << 1 : data_operandA; 

    wire [31:0] aluResult; 
    wire throwAway1, throwAway2, throwAway3; 
    alu ALU(runningProduct[64:33], multiplicand, aluOp, 5'd0, aluResult, throwAway1, throwAway2, throwAway3); 

    wire signed [64:0] unshiftedProduct; 
    twoToOneMux nopMux(unshiftedProduct[64:33], nop || data_resultRDY, aluResult, runningProduct[64:33]); 
    assign unshiftedProduct[32:0] = runningProduct[32:0]; 

    wire [64:0] shiftProductOut; 

    assign shiftProductOut = shiftProduct ? (unshiftedProduct >>> 2) : unshiftedProduct; 

    wire [64:0] initialRegInput; 
    assign initialRegInput[0] = 0; 
    assign initialRegInput[32:1] = data_operandB; 
    assign initialRegInput[64:33] = 32'b0; 

    // always @(data_resultRDY) begin
    //     #5; 
    //     $display("running product: %b, exception: %b, xor check: %b, and check: %b, results check: %b", runningProduct[64:32], data_exception, w_overflowCheck1, w_overflowCheck2, w_overflowCheck3); 
    //     //$finish; 
    // end

    assign regInput = ctrl_MULT ? initialRegInput : shiftProductOut; 

    register65 productRegister(runningProduct, clock, 1'b1, 1'b0, regInput); 

    assign data_result = runningProduct[32:1]; 

    wire w_overflowCheck1; 
    wire w_overflowCheck2; 
    
    assign w_overflowCheck1 = |runningProduct[64:32]; 
    assign w_overflowCheck2 = &runningProduct[64:32]; 
    assign data_exception = w_overflowCheck1 && !w_overflowCheck2 || (data_operandA[31] && !(|data_operandA[30:0]) && (&data_operandB)); 

endmodule