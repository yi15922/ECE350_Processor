module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;


    // Subtract? 
    wire w_sub; 
    wire w_notOpcode1, w_notOpcode2; 
    not notOpcode1(w_notOpcode1, ctrl_ALUopcode[1]); 
    not notOpcode2(w_notOpcode2, ctrl_ALUopcode[2]);
    and sub(w_sub, ctrl_ALUopcode[0], w_notOpcode1, w_notOpcode2); 

    // Invert input B
    wire [31:0] w_notB; 
    inverter notB(w_notB, data_operandB); 

    // Select inverted if subtract
    wire [31:0] w_AdderB; 
    twoToOneMux Bmux(w_AdderB, w_sub, data_operandB, w_notB); 
    
    // add/sub operation
    wire [31:0] w_addResult; 
    adder_32 adder(w_addResult, overflow, data_operandA, w_AdderB, w_sub);  

    // If result is 0, equal
    assign isNotEqual = data_result ? 1 : 0; 


    // If result is negative, less than
    // If overflow, do the opposite

    wire w_notResult31; 
    not notResult31(w_notResult31, data_result[31]); 
    assign isLessThan = overflow ? w_notResult31 : data_result[31]; 


    // Bitwise AND output
    wire [31:0] w_AND; 
    and_bitwise AND(w_AND, data_operandA, data_operandB); 

    // Bitwise OR output
    wire [31:0] w_OR; 
    or_bitwose OR(w_OR, data_operandA, data_operandB); 

    // SLL
    wire [31:0] w_SLL; 
    barrelshifter shifter(w_SLL, data_operandA, ctrl_shiftamt); 

    // SRA
    wire [31:0] w_SRA; 
    SRA sra(w_SRA, data_operandA, ctrl_shiftamt); 


    // ALU output
    mux_8 outputMux(data_result, ctrl_ALUopcode[2:0], w_addResult, w_addResult, w_AND, w_OR, w_SLL, w_SRA, 0, 0); 

    

endmodule