module ALU_tb_2; 
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    alu tester(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow); 

    assign data_operandA = 1343; 
    assign data_operandB = 100000; 
    assign ctrl_shiftamt = 0; 

    assign ctrl_ALUopcode = 3'b001; 
    assign ctrl_shiftamt = 0; 

    initial begin
        #50; 
        $display("A: %d, B: %d, ALUOP: %d, Result: %d, NE: %d, LT: %d, Overflow: %d", data_operandA, data_operandB, ctrl_ALUopcode, data_result, isNotEqual, isLessThan, overflow); 

        $finish; 
    end
endmodule
