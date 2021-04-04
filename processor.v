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

    wire [31:0] w_PC_in, w_incrementedPC, w_branchedPC; 
    wire w_jump; 
    wire [31:0] w_jumpAddress; 
    
    wire w_stall, w_branch; 
    wire [31:0] PC_in_branch; 
    assign PC_in_branch = w_branch ? w_branchedPC : w_incrementedPC;
    assign w_PC_in = w_jump ? w_jumpAddress : PC_in_branch; 
    regPC PC(address_imem, clock, !w_stall, reset, w_PC_in); 

    wire w_nextInsnOverflow;
    adder_32 nextInsn(w_incrementedPC, w_nextInsnOverflow, address_imem, 32'b1, 1'b0); 

    wire [31:0] w_FD_PC_out, w_FD_IR_out, w_FD_IR_in; 
    assign w_FD_IR_in = (w_branch || w_jump) ? 32'd0 : q_imem; 
    regFD FD(w_FD_PC_out, w_FD_IR_out, clock, !w_stall, reset, w_PC_in, w_FD_IR_in); 

    wire D_BLT, D_BNE; 
    wire [4:0] D_opcode; 
    assign D_opcode = w_FD_IR_out[31:27]; 
    assign D_BLT = D_opcode == 5'b00110; 
    assign D_BNE = D_opcode == 5'b00010; 
    // Read from $rd if this is a branch or jr
    wire w_jr;
    assign ctrl_readRegA = (D_BNE || D_BLT || w_jr) ? w_FD_IR_out[26:22] : w_FD_IR_out[21:17]; 
    // Read from $rs if this is a branch, read from $rd if is a store, read from rt otherwise. 
    wire [4:0] readRegBstore; 
    assign readRegBstore = D_opcode == 5'b00111 ? w_FD_IR_out[26:22] : w_FD_IR_out[16:12]; 
    assign ctrl_readRegB = (D_BNE || D_BLT) ? w_FD_IR_out[21:17] : readRegBstore; 

    assign ctrl_writeEnable = (w_MW_IR_out[31:27] == 5'b00000) || (w_MW_IR_out[31:27] == 5'b00101) || 
                                (w_MW_IR_out[31:27] == 5'b00011) || (w_MW_IR_out[31:27] == 5'b10101) || 
                                (w_MW_IR_out[31:27] == 5'b01000); 

    wire [31:0] w_DX_PC_out, w_DX_A_out, w_DX_B_out, w_DX_IR_out, w_DX_IR_in; 
    assign w_jr = w_DX_IR_out[31:27] == 5'b00100; 

    wire DX_writeEnable, w_multdivReady, X_isMult, X_isDiv, w_multdivException; 
    //assign DX_writeEnable = !((X_isMult || X_isDiv) && !w_multdivReady); 
    assign w_DX_IR_in = (w_stall || w_branch || w_jump) ? 32'd0 : w_FD_IR_out; 
    regDX DX(w_DX_PC_out, w_DX_IR_out, w_DX_A_out, w_DX_B_out, clock, 1'b1, reset, w_FD_PC_out, w_DX_IR_in, data_readRegA, data_readRegB); 
    
    wire X_isjal; 
    wire [4:0] X_opcode, X_aluop; 
    assign X_opcode = w_DX_IR_out[31:27]; 
    assign X_aluop = w_DX_IR_out[6:2]; 
    wire X_isRType; 
    assign X_isRType = X_opcode == 5'b00000; 
    wire [31:0] w_alu_in_A, w_alu_in_B, w_aluOut; 

    /* MULTDIV STAGE */ 
    wire [31:0] w_multdivOut;  
    wire X_isMultDiv, multdivInProgress, savedMultdiv; 
    dffe multdivRecord(savedMultdiv, X_isMultDiv, clock, X_isMultDiv, w_multdivReady); 
    assign multdivInProgress = X_isMultDiv ? X_isMultDiv : savedMultdiv; 

    assign X_isMultDiv = X_isMult || X_isDiv; 
    assign X_isMult = X_isRType && (X_aluop == 5'b00110); 
    assign X_isDiv = X_isRType && (X_aluop == 5'b00111); 
    multdiv MultDiv(w_alu_in_A, w_alu_in_B, X_isMult, X_isDiv, clock, w_multdivOut, w_multdivException, w_multdivReady); 
    wire [31:0] w_PW_IR_out, w_PW_P_out; 
    regPW PW(w_PW_IR_out, w_PW_P_out, clock, !savedMultdiv, reset, w_DX_IR_out, w_multdivOut);

    

    assign w_jump = (X_opcode == 5'b00001) || (X_isjal) || (X_opcode == 5'b00100); 
    assign w_jumpAddress = (X_opcode == 5'b00100) ? w_alu_in_A : w_DX_IR_out[26:0]; 

    wire ctrl_immediate, w_alu_NE, w_alu_LT, w_alu_Overflow; 
    assign ctrl_immediate = (X_opcode == 5'b00101) || (X_opcode == 5'b00111) ||
                            (X_opcode == 5'b01000);
    wire [31:0] data_signedImmediate, regoutB, w_XM_O_out; 
    signExtender extender(data_signedImmediate, w_DX_IR_out[16:0]); 

    wire [1:0] select_regoutBMux; 
    wire X_BLT, X_BNE; 
    mux_4 regoutBMux(regoutB, select_regoutBMux, w_XM_O_out, data_writeReg, w_DX_B_out, 32'bz); 

    assign w_alu_in_B = ctrl_immediate ? data_signedImmediate : regoutB; 
    // Make ALUop subtract if branching
    wire [4:0] ALUsub; 
    assign ALUsub = (X_BLT || X_BNE) ? 5'b00001 : w_DX_IR_out[6:2]; 
    wire [4:0] w_aluOp; 
    assign w_aluOp = ctrl_immediate ? 5'b0 : ALUsub; 
    
    wire [1:0] select_ALUinAMux; 
    mux_4 ALUinAMux(w_alu_in_A, select_ALUinAMux, w_XM_O_out, data_writeReg, w_DX_A_out, 32'bz); 
    alu ALU(w_alu_in_A, w_alu_in_B, w_aluOp, w_DX_IR_out[11:7], w_aluOut, w_alu_NE, w_alu_LT, w_alu_Overflow); 
    assign X_BLT = X_opcode == 5'b00110; 
    assign X_BNE = X_opcode == 5'b00010; 
    assign w_branch = (X_BLT && w_alu_LT) || (X_BNE && w_alu_NE); 

   
    wire w_branchAdderOverflow;
    adder_32 branchAdder(w_branchedPC, w_branchAdderOverflow, data_signedImmediate, w_DX_PC_out, 1'b0); 

    wire [31:0] w_XM_IR_out, w_XM_B_out, w_XM_O_in, w_XM_IR_in; 
    wire [4:0] M_opcode; 

    wire select_dmemMux, X_setx; 
    assign data = select_dmemMux ? w_XM_B_out : data_writeReg; 
    assign X_setx = w_DX_IR_out[31:27] == 5'b10101;
    assign w_XM_O_in = X_setx ? w_DX_IR_out : w_aluOut; 
    assign w_XM_IR_in[31:27] = w_DX_IR_out[31:27]; 
    assign w_XM_IR_in[21:0] = w_DX_IR_out[21:0]; 
    assign w_XM_IR_in[26:22] = X_setx ? 5'b11110 : w_DX_IR_out[26:22]; 

    regXM XM(w_XM_IR_out, w_XM_O_out, w_XM_B_out, clock, 1'b1, reset, w_XM_IR_in, w_XM_O_in, w_DX_B_out);
    assign address_dmem = w_XM_O_out; 
    assign wren = (M_opcode == 5'b00111); 

    wire [31:0] w_MW_IR_out, w_MW_O_out, w_MW_D_out, w_MW_IR_in, w_MW_O_in, w_MW_O_inMultdiv; 
    assign X_isjal = X_opcode == 5'b00011; 
    assign w_MW_IR_in = w_multdivReady ? w_PW_IR_out : w_XM_IR_out; 

    wire PW_isMultDiv; 
    assign PW_isMultDiv = w_PW_IR_out[31:27] == 5'b00000 && (w_PW_IR_out[6:2] == 5'b00110 || w_PW_IR_out[6:2] == 5'b00111); 

    assign w_MW_O_inMultdiv = PW_isMultDiv && w_multdivReady ? w_multdivOut : w_XM_O_out; 
    assign w_MW_O_in = X_isjal ? w_DX_PC_out : w_MW_O_inMultdiv; 
    regMW MW(w_MW_IR_out, w_MW_O_out, w_MW_D_out, clock, 1'b1, reset, w_MW_IR_in, w_MW_O_in, q_dmem); 

    assign M_opcode = w_XM_IR_out[31:27]; 

    // Choose multdiv results when result is ready
    wire w_isMemoryLoad = (w_MW_IR_out[31:27] == 5'b01000); 

    assign data_writeReg = w_isMemoryLoad ? w_MW_D_out : w_MW_O_out; 
    // write to register 31 if instruction is jal
    assign ctrl_writeReg = (X_isjal) ? 5'd31 : w_MW_IR_out[26:22]; 

    bypassControl bypass(select_dmemMux, select_ALUinAMux, select_regoutBMux, w_DX_IR_out, w_XM_IR_out, w_MW_IR_out); 
	stallControl stall(w_stall, w_FD_IR_out, w_DX_IR_out, w_multdivReady, w_PW_IR_out, clock); 
    /* END CODE */

    // always @(posedge clock) begin 
        
    //     $display("lw: %b, sw: %b, dmemIn: %d, regfileIn: %d, instruction: %b", w_isMemoryLoad, wren, data, data_writeReg, w_FD_IR_out); 
    // end

endmodule
