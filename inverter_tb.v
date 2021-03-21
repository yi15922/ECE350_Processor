module inverter_tb; 
    wire [31:0] in, out; 

    inverter invert(out, in); 

    assign in = 100000; 

    initial begin 
        #50; 
        $display("Input: %b, output: %b", in, out); 
        $finish; 
    end
endmodule