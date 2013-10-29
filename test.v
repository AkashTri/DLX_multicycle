`include "CPU.v"              //including the file with CPU module

//Stimulus Module
module CPU_tb;
   wire [31:0] Cycle, PCReg, RegA, RegB, ALUOutReg, Instruction;
   reg 	       Clock = 1'b0;
   wire [3:0] State;
   always
     begin
	#5 Clock = ~Clock;
     end
   
   CPU cpu(Cycle, PCReg, RegA, RegB, ALUOutReg, Instruction, Clock,State);
   
   initial
     begin
        $monitor($time,"\nCycle: %d,\n PCReg: %d,\n Instruction: %b,\nRegA: %d,\n RegB: %d,\nALUOutReg: %d \n\nNext State : %b\n\n", Cycle, PCReg, Instruction, RegA, RegB, ALUOutReg,State);
     end

   initial
     #1500 $finish;  //Specify the finish time
   
endmodule // CPU_tb
