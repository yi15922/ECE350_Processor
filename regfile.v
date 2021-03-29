module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] w_readDecoder1, w_readDecoder2; 
	decoder readDecoder1(w_readDecoder1, ctrl_readRegA); 
	decoder readDecoder2(w_readDecoder2, ctrl_readRegB);

	wire [31:0] w_writeDecoder; 
	decoder writeDecoder(w_writeDecoder, ctrl_writeReg); 

	genvar i; 
	
	register zeroRegister(data_readRegA, data_readRegB, !clock, 1'b0, w_readDecoder1[0], w_readDecoder2[0], reset, 0); 

	generate
		for (i = 1; i < 32; i = i + 1) begin: loop
			wire w_write; 
			and write(w_write, ctrl_writeEnable, w_writeDecoder[i]); 
			register oneRegister(data_readRegA, data_readRegB, !clock, w_write, w_readDecoder1[i], w_readDecoder2[i], ctrl_reset, data_writeReg); 
		end
	endgenerate
endmodule
