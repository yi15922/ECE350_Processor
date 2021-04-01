# Processor Checkpoint for ECE 350
### Yi Chen (yc311)

__Note:__ This processor is still in progress, therefore implementation details might be slightly different than described below. 

### General Structure
- This is a 5 stage pipelined MIPS processor, with integer multiplication and division capabilities. 
- The processor uses CLA adders and Booth's algorithm for fast arithmetic operations. 
- The processor has hardware interlocking to prevent data hazards. 
- Between each pipeline stage, there is a register that latches information from the previous stage. These latches are built as specialized registers. There is one extra latch for the `multDiv` module. 
- The modules `stallControl` and `bypassControl` are for stalling and various types of bypasses. 

### Arithmic
- The processor uses a normal ALU for simple arithmetic, bypassing and stalling when necessary. 
- For multiplication and division operations, the processor uses the `multDiv` module. While multDiv is in progress, operations that do not affect the `$rd` of the `mul` or `div` instruction are executed normally. If a instruction tries to read or write to that register, the processor will stall until the `multDiv` result is ready. 
- Output of `multDiv` always bypasses the memory stage directly to the writeback stage. 
- In instruction files without `mul` or `div`, the ready signal for `multDiv` can sometimes be asserted, therefore components that rely on that signal must check that there is a currently active `multDiv` operation by checking the `IR` output of the `regPW` latch. 