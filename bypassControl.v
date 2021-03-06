module bypassControl(dmemMux, ALUinAMux, regoutBMux, DX_IR, XM_IR, MW_IR);
    input[31:0] DX_IR, XM_IR, MW_IR; 
    output[1:0] ALUinAMux_intermediate, regoutBMux_intermediate, ALUinAMux, regoutBMux; 
    output dmemMux; 

    wire [4:0] DX_IR_A, DX_IR_B, XM_IR_RD, MW_IR_RD; 
    // Make A rd if this is a jr
    assign DX_IR_A = DX_IR[31:27] == 5'b00100 ? DX_IR[26:22] : DX_IR[21:17]; 
    assign DX_IR_B = DX_IR[16:12];
    assign XM_IR_RD = XM_IR[26:22]; 
    assign MW_IR_RD = MW_IR[26:22]; 

    wire zeroRS, zeroRT; 
    assign zeroRS = (DX_IR_A == 5'd0); 
    assign zeroRT = (DX_IR_B == 5'd0);

    assign ALUinAMux_intermediate[0] = (DX_IR_A == MW_IR_RD) && !(DX_IR_A == XM_IR_RD); 
    assign ALUinAMux_intermediate[1] = !(DX_IR_A == XM_IR_RD) && !(DX_IR_A == MW_IR_RD); 

    assign regoutBMux_intermediate[0] = (DX_IR_B == MW_IR_RD) && !(DX_IR_B == XM_IR_RD);
    assign regoutBMux_intermediate[1] = !(DX_IR_B == XM_IR_RD) && !(DX_IR_B == MW_IR_RD); 

    assign ALUinAMux = (zeroRS || (MW_IR[31:27] == 5'b00111)) ? 2'b10 : ALUinAMux_intermediate; 
    assign regoutBMux = zeroRT ? 2'b10 : regoutBMux_intermediate; 

    wire isMemoryStore; 
    assign isMemoryStore = XM_IR[31:27] == 5'b00111; 
    // If memory store immediate followed by load into same register, make this mux 0, otherwise 1. 
    assign dmemMux = !(isMemoryStore && (XM_IR_RD == MW_IR_RD)); 

    // assign dmemMux = 1'd1; 
    // assign ALUinAMux = 2'd2; 
    // assign regoutBMux = 2'd2; 

    // always @(MW_IR, DX_IR, XM_IR) begin
    //     $display("MW bypass: %b, ALUinAMux: %d, regoutBMux: %d, DX_RS: %d, DX_RT: %d, XM_RD: %d, MW_RD: %d", !dmemMux, ALUinAMux, regoutBMux, DX_IR_A, DX_IR_B, XM_IR_RD, MW_IR_RD); 
    // end


endmodule