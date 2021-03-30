module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire w_mult; 
    dffe resultSelect(w_mult, ctrl_MULT, clock, ctrl_MULT || ctrl_DIV, 1'b0); 

    wire [31:0] w_multResult, w_divResult, savedOperandA, savedOperandB, multdivInA, multdivInB; 
    wire w_multException, w_divException, w_multRDY, w_divRDY; 

    reg32 operandA(savedOperandA, !clock, ctrl_MULT || ctrl_DIV, 1'b0, data_operandA); 
    reg32 operandB(savedOperandB, !clock, ctrl_MULT || ctrl_DIV, 1'b0, data_operandB); 

    assign multdivInA = ctrl_MULT || ctrl_DIV ? data_operandA : savedOperandA; 
    assign multdivInB = ctrl_MULT || ctrl_DIV ? data_operandB : savedOperandB; 

    mult multModule(multdivInA, multdivInB, ctrl_MULT, clock, w_multResult, w_multException, w_multRDY);
    div divModule(multdivInA, multdivInB, ctrl_DIV, clock, w_divResult, w_divException, w_divRDY); 

    assign data_result = w_mult ? w_multResult : w_divResult; 
    assign data_exception = w_mult ? w_multException : w_divException; 
    assign data_resultRDY = w_mult ? w_multRDY : w_divRDY;  

    // always @(data_resultRDY) begin
    //     #5; 
    //     $display("mult: %b, div: %b, data_result: %d, ready: %b", ctrl_MULT, ctrl_DIV, data_result, data_resultRDY); 
    // end


endmodule