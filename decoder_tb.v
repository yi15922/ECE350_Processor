module decoder_tb();
    
    wire [31:0] out; 
    wire [4:0] select; 

    assign select = 15;

    decoder decode(out, select); 

    initial begin
        #50; 
        $display("Select: %d, out: %b", select, out); 

        $finish; 
    end


endmodule