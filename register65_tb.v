module register65_tb(); 
    reg clk, input_enable, reset; 
    wire [64:0] data_out; 
    reg [64:0] data_in; 

    register65 test(data_out, clk, input_enable, reset, data_in); 

    integer i = 234; 

    initial begin 
        //clk = 0; 
        #50; 
        input_enable = 1; 
        assign data_in = i; 
        clk = 1; 


        #50; 
        $display("clk: %b, input: %b, output: %b", clk, data_in, data_out); 

        $finish; 
    end

endmodule


