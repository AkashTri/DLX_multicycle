`include "control.v"
`include "datapath.v"

//CPU Module
module CPU(Cycle, PCReg, RegA, RegB, ALUOutReg, Instruction, Clock,State);
   output [31:0] Cycle, PCReg, RegA, RegB, ALUOutReg, Instruction;
   input 	 Clock;
   output [3:0] State;
   wire [5:0] 	 Opcode,Func;
   wire 	 RegWrite,ALUSrcA,MemRead,MemWrite,IorD,IRWrite,
		 PCWrite,PCWriteCond,Zero,Overflow;
   wire [1:0] 	 PCSource, ALUOp, ALUSrcB,RegDst,MemtoReg;

   //Instantiating the Control unit module
   Control control(RegDst,RegWrite,ALUSrcA,MemRead,MemWrite,MemtoReg,IorD,
		   IRWrite,PCWrite,PCWriteCond,ALUOp,ALUSrcB,PCSource,Opcode, 
		   Func,Zero,Overflow,Clock,State);

   //Instantiating Datapath
   DataPath data_path(Cycle, PCReg, RegA, RegB, ALUOutReg, Instruction, Opcode,
		      PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg,
		      IRWrite, PCSource, ALUOp, ALUSrcB, ALUSrcA, RegWrite, 
		      RegDst,Zero,Overflow, Clock);
endmodule // CPU

