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

    wire [31:0] savedOperandA, savedOperandB; 
    dffe operandA(savedOperandA, data_operandA, clock, ctrl_MULT || ctrl_DIV, 1'b0); 
    dffe operandB(savedOperandB, data_operandB, clock, ctrl_MULT || ctrl_DIV, 1'b0); 

    wire [31:0] w_multResult, w_divResult; 
    wire w_multException, w_divException, w_multRDY, w_divRDY; 

    mult multModule(savedOperandA, savedOperandB, ctrl_MULT, clock, w_multResult, w_multException, w_multRDY);
    div divModule(savedOperandA, savedOperandB, ctrl_DIV, clock, w_divResult, w_divException, w_divRDY); 

    assign data_result = w_mult ? w_multResult : w_divResult; 
    assign data_exception = w_mult ? w_multException : w_divException; 
    assign data_resultRDY = w_mult ? w_multRDY : w_divRDY;  

    // always @(data_resultRDY) begin
    //     #5; 
    //     $display("mult: %b, div: %b, data_result: %d, ready: %b", ctrl_MULT, ctrl_DIV, data_result, data_resultRDY); 
    // end


endmodule