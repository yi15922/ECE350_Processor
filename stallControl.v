module stallControl(stall, FD_IR, DX_IR, multDivReady, PW_IR, clock);  
    input [31:0] FD_IR, DX_IR, PW_IR; 
    input multDivReady, clock; 
    output stall; 

    wire [4:0] FD_IR_RS, FD_IR_RT, DX_IR_RD, PW_IR_RD, D_opcode, D_aluop; 
    assign FD_IR_RS = FD_IR[21:17]; 
    assign FD_IR_RT = FD_IR[16:12]; 
    assign DX_IR_RD = DX_IR[26:22]; 
    assign PW_IR_RD = PW_IR[26:22]; 
    assign D_opcode = FD_IR[31:27]; 
    assign D_aluop = FD_IR[6:2]; 

    wire [4:0] X_opcode, X_aluop; 
    assign X_opcode = DX_IR[31:27]; 
    assign X_aluop = DX_IR[6:2]; 
    wire X_isRType; 
    assign X_isRType = X_opcode == 5'b00000; 
    wire X_isMult, X_isDiv, X_isMultDiv;
    assign X_isMult = X_isRType && (X_aluop == 5'b00110); 
    assign X_isDiv = X_isRType && (X_aluop == 5'b00111); 
    assign X_isMultDiv = X_isMult || X_isDiv; 

    wire savedMultdiv, multdivInProgress; 
    dffe multdivRecord(savedMultdiv, X_isMultDiv, clock, X_isMultDiv, multDivReady); 
    assign multdivInProgress = X_isMultDiv ? X_isMultDiv : savedMultdiv; 

    wire multdivStall; 
    assign multdivStall = multdivInProgress && ((FD_IR_RS == PW_IR_RD) || (FD_IR_RT == PW_IR_RD) || (FD_IR_RS == DX_IR_RD) || (FD_IR_RT == DX_IR_RD) || D_aluop == 5'b00110 || D_aluop == 5'b00111); 

    

    wire DXLoad, FDStore; 
    //assign ignore = (FD_IR_RS == 5'd0) || (FD_IR_RT == 5'd0); 
    assign DXLoad = DX_IR[31:27] == 5'b01000; 
    assign FDStore = FD_IR[31:20] == 5'b00111; 

    assign stall = DXLoad && ((FD_IR_RS == DX_IR_RD) || ((FD_IR_RT == DX_IR_RD) && (!FDStore))) || multdivStall; 


    // always @(FD_IR) begin
    //     #20; 
    //     $display("FD_IR: %b, XM_IR: %b, DX_IR: %b, ignore: %b, stall: %b", FD_IR, XM_IR, DX_IR, ignore, stall); 
    //     //$display("stall: %b, FD_RS: %b, FD_RT: %b, DX_RD: %b, XM_RD: %b", stall, FD_IR_RS, FD_IR_RT, DX_IR_RD, XM_IR_RD); 
    // end

    

endmodule