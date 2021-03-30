module dataHazard(hazard, FD_IR_A_out, FD_IR_B_out, DX_IR_RD_out, XM_IR_RD_out); 
    input [5:0] FD_IR_A_out, FD_IR_B_out, DX_IR_RD_out, XM_IR_RD_out; 
    output hazard; 

    assign hazard = (FD_IR_A_out == DX_IR_RD_out) || (FD_IR_B_out == DX_IR_RD_out) || (FD_IR_A_out == XM_IR_RD_out) || (FD_IR_B_out == XM_IR_RD_out); 

endmodule