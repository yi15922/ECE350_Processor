module signExtender_tb(); 
    wire [16:0] data_in; 
    wire [31:0] data_out; 

    assign data_in = 17'b10000100100100101; 


    signExtender extender(data_out, data_in); 

    initial begin
        #50; 
        $display("datain: %b, dataout: %b", data_in, data_out); 
        $finish; 
    end

    
endmodule