`timescale 1ns / 1ps
//`include "stdlib.h"
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to test your processor for functionality.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must set the parameter when compiling to use the memory file of the test you created using the assembler
 * and load the appropriate verification file.
 *
 * For example, you would add sample as your parameter after assembling sample.s
 *
 **/

module Wrapper_tb #(parameter FILE = "nop");

	// FileData
	localparam DIR = "tests/";

	// Inputs to the processor
	reg clock = 0, reset = 0;

	// I/O for the processor
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({DIR, FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1_in), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

	// Create the clock
	always
		#10 clock = ~clock; 

	//////////////////
	// Test Harness //
	//////////////////

	// Wires for Test Harness
	wire[4:0] rs1_test, rs1_in;
	reg testMode = 0; 
	reg[7:0] num_cycles;
	reg[15*8:0] exp_text;
	reg null;

	// Connect the reg to test to the for loop
	assign rs1_test = reg_to_test;

	// Hijack the RS1 value for testing
	assign rs1_in = testMode ? rs1_test : rs1;

	// Expected Value from File
	reg signed [31:0] exp_result;

	// Where to store file error codes
	integer expFile, diffFile, actFile, expScan; 

	// Metadata
	integer errors = 0,
					cycles = 0,
					reg_to_test = 0;

	initial begin
		// Check if the parameter exists
		if(FILE == 0) begin
			$display("Please specify the test");
			$finish;
		end

		// Output file name
		$dumpfile({FILE, ".vcd"});
		// Module to capture and what level, 0 means all wires
		$dumpvars(0, Wrapper_tb);

		$display();

		// Read the expected file
		expFile = $fopen({DIR, FILE, "_exp.txt"}, "r");

			// Check for any errors in opening the file
		if(!expFile) begin
			$display("Couldn't read the expected file.",
				"\nMake sure it is in the \"tests\" directory and the %0s_exp.txt file exists.", FILE);
			$finish;
		end

		// Create the files to store the output
		actFile   = $fopen({DIR, FILE, "_actual.txt"},   "w");
		diffFile  = $fopen({DIR, FILE, "_diff.txt"},  "w");

		// Write the header to the diffFile
		$fdisplay(diffFile, "Reg %3sExpected %5sActual", "", "");

		// Ignore the header of the Expected file
		expScan = $fscanf(expFile, "num cycles:%d", 
			num_cycles);

		// Check that the number of cycles was read
		if(expScan != 1) begin
			$display("Error reading the %0s file.", {FILE, "_exp.txt"});
			$display("Make sure that file starts with num cycles: NUM_CYCLES.");;
			$display("Where NUM_CYCLES is a positive integer");
		end

		// Run for the number of cycles specified 
		for (cycles = 0; cycles < num_cycles; cycles = cycles + 1) begin
			
			// Every rising edge, write to the actual file
			@(posedge clock);
			if (rwe) begin
				$fdisplay(actFile, "Wrote %0d into register %0d", rData, rd);
			end
		end

		// Activate the test harness
		testMode = 1;

		// Check the values in the regfile
		for (reg_to_test = 0; reg_to_test < 32; reg_to_test = reg_to_test + 1) begin
			
			// Obtain the register value
			expScan =  $fscanf(expFile, "%s", exp_text);
			expScan = $sscanf(exp_text, "r%d=%d", null, exp_result);
			
			// Allow the register value to stabilize
			#1;

			// Write the register value to the actual file
			$fdisplay(actFile, "Reg %2d: %11d", rs1_test, regA);
			
			// Compare the Values 
			if (exp_result !== regA) begin
				$fdisplay(diffFile, "%3d %11d %11d",
					rs1_test, exp_result, regA);
				errors = errors + 1;
			end
		end

		// Close the Files
		$fclose(expFile);
		$fclose(actFile);
		$fclose(diffFile);

		// Display the tests and errors
		$display("Finished %0d cycle%c with %0d error%c", cycles, "s"*(cycles != 1), errors, "s"*(errors != 1));

		#100;
		$finish;
	end
endmodule
