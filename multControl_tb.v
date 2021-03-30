`timescale 1ns/100ps
module multControl_tb(); 
    reg clock = 0; 
    always
        #20 clock = !clock; 



    wire add, sub, shiftMultiplicand, shiftProduct, ready, nop; 
    reg start;
    reg [2:0] data_in = 0; 

    multControl control(add, sub, shiftMultiplicand, shiftProduct, nop, ready, data_in, clock, start); 

    //assign data_in = 000; 

    initial begin 
        assign start = 1; 
        #40; 
        assign start = 0; 

        #3000; 
        $finish; 

    end

    always
        #10 data_in[0] = !data_in[0]; 
    always
        #20 data_in[1] = !data_in[1]; 
    always
        #40 data_in[2] = !data_in[2]; 

    

    always @(data_in) begin
        #5; 
        $display("data_in: %b, add: %d, sub: %d, shift: %d, shiftProduct: %d, nop: %d", data_in, add, sub, shiftMultiplicand, shiftProduct, nop); 
    end

endmodule
