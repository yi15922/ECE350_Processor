module stallControl(stall, FD_IR, XM_IR, DX_IR);  
    input [31:0] FD_IR, XM_IR, DX_IR; 
    output stall; 

    wire [4:0] FD_IR_RS, FD_IR_RT, DX_IR_RD, XM_IR_RD; 
    assign FD_IR_RS = FD_IR[21:17]; 
    assign FD_IR_RT = FD_IR[16:12]; 
    assign DX_IR_RD = DX_IR[26:22]; 
    assign XM_IR_RD = XM_IR[26:22]; 

    wire ignore; 
    assign ignore = (FD_IR == 32'dz) || (XM_IR == 32'dz) || (DX_IR == 32'dz) || 
                    (FD_IR == 32'd0) || (XM_IR == 32'd0) || (DX_IR == 32'd0); 

    // assign stall = !ignore && ((FD_IR_RS == DX_IR_RD) || (FD_IR_RT == DX_IR_RD) || 
    //                 (FD_IR_RS == XM_IR_RD) || (FD_IR_RT == XM_IR_RD)); 

    assign stall = 0; 

    always @(FD_IR) begin
        $display("FD_IR: %b, XM_IR: %b, DX_IR: %b", FD_IR, XM_IR, DX_IR); 
        //$display("stall: %b, FD_RS: %b, FD_RT: %b, DX_RD: %b, XM_RD: %b", stall, FD_IR_RS, FD_IR_RT, DX_IR_RD, XM_IR_RD); 
    end

    

endmodule