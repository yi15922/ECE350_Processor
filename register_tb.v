module register_tb(); 
    reg clk, input_enable, output_enable1, output_enable2, reset; 
    wire [31:0] data_out1, data_out2; 
    reg [31:0] data_in; 

    register test(data_out1, data_out2, clk, input_enable, output_enable1, output_enable2, reset, data_in); 

    integer i = 234; 

    initial begin 
        clk = 0; 
        #50; 
        input_enable = 1; 
        output_enable1 = 1; 
        output_enable2 = 1; 
        assign data_in = i; 
        clk = 1; 


        #50; 
        $display("clk: %b, input: %b, out enable 1: %b, out enable 2: %b, output1: %b output2: %b", clk, data_in, output_enable1, output_enable2, data_out1, data_out2); 

        $finish; 
    end

endmodule


