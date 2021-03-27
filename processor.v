/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    wire [31:0] w_PC_in, w_incrementedPC; 
    // TODO: add mux here when implementing branches
    assign w_PC_in = w_incrementedPC; 
    regPC PC(address_imem, clock, 1'b1, reset, w_PC_in); 

    wire w_nextInsnOverflow;
    adder_32 nextInsn(w_incrementedPC, w_nextInsnOverflow, address_imem, 32'b1, 1'b0); 

    wire [31:0] w_FD_PC_out, w_FD_IR_out; 
    regFD FD(w_FD_PC_out, w_FD_IR_out, clock, 1'b1, reset, w_PC_in, q_imem); 

    assign ctrl_readRegA = w_FD_IR_out[21:17]; 
    // Making read data from $rd if this is a sw instruction
    assign ctrl_readRegB = w_FD_IR_out[31:27] == 5'b00111 ? w_FD_IR_out[26:22] : w_FD_IR_out[16:12]; 
    assign ctrl_writeEnable = (w_MW_IR_out[31:27] == 5'b00000) || (w_MW_IR_out[31:27] == 5'b00101) || 
                                (w_MW_IR_out[31:27] == 5'b00011) || (w_MW_IR_out[31:27] == 5'b10101) || 
                                (w_MW_IR_out[31:27] == 5'b01000); 

    wire [31:0] w_DX_PC_out, w_DX_A_out, w_DX_B_out, w_DX_IR_out; 
    regDX DX(w_DX_PC_out, w_DX_IR_out, w_DX_A_out, w_DX_B_out, !clock, 1'b1, reset, w_FD_PC_out, w_FD_IR_out, data_readRegA, data_readRegB); 

    wire [31:0] w_alu_in_B, w_aluOut; 
    wire ctrl_immediate, w_alu_NE, w_alu_LT, w_alu_Overflow; 
    assign ctrl_immediate = (w_DX_IR_out[31:27] == 5'b00101) || (w_DX_IR_out[31:27] == 5'b00111) ||
                            (w_DX_IR_out[31:27] == 5'b01000) || (w_DX_IR_out[31:27] == 5'b00010) || 
                            (w_DX_IR_out[31:27] == 5'b00110); 
    wire [31:0] data_signedImmediate; 
    signExtender extender(data_signedImmediate, w_DX_IR_out[16:0]); 
    assign w_alu_in_B = ctrl_immediate ? data_signedImmediate : w_DX_B_out; 
    wire [4:0] w_aluOp; 
    assign w_aluOp = ctrl_immediate ? 5'b0 : w_DX_IR_out[6:2];
    alu ALU(w_DX_A_out, w_alu_in_B, w_aluOp, w_DX_IR_out[11:7], w_aluOut, w_alu_NE, w_alu_LT, overflow); 

    wire [31:0] w_jumpedPC; 
    wire w_jumpAdderOverflow;
    adder_32 jumpAdder(w_jumpedPC, w_jumpAdderOverflow, data_signedImmediate, w_DX_PC_out, 1'b0); 

    wire [31:0] w_XM_O_out, w_XM_IR_out; 
    regXM XM(w_XM_IR_out, w_XM_O_out, data, !clock, 1'b1, reset, w_DX_IR_out, w_aluOut, w_DX_B_out);
    assign address_dmem = w_XM_O_out; 
    assign wren = (w_XM_IR_out[31:27] == 5'b00111); 

    wire [31:0] w_MW_IR_out, w_MW_O_out, w_MW_D_out; 
    regMW MW(w_MW_IR_out, w_MW_O_out, w_MW_D_out, !clock, 1'b1, reset, w_XM_IR_out, w_XM_O_out, q_dmem); 

    wire w_isMemoryLoad = (w_MW_IR_out[31:27] == 5'b01000); 
    assign data_writeReg = w_isMemoryLoad ? w_MW_D_out : w_MW_O_out; 
    assign ctrl_writeReg = w_MW_IR_out[26:22]; 
	/* END CODE */

    // always @(posedge clock) begin 
        
    //     $display("registerWE: %b, regIn: %d, dataIn: %d, dataOut: %d, lw: %b, sw: %b, address: %d", ctrl_writeEnable, data_writeReg, w_MW_D_out, q_dmem, w_isMemoryLoad, wren, address_dmem); 
    // end

endmodule
