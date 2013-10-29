`include "memory.v"
`include "InstructionRegister.v"
`include "RegisterFile.v"
`include "alu.v"
`include "ALUControl.v"
`include "Mux4to1.v"

//Datapath Implementation
module DataPath (Cycle,PCReg,RegA,RegB,ALUOutReg,Instruction,Opcode,
		 PCWriteCond,PCWrite,IorD,MemRead,MemWrite,MemToReg,IRWrite,
		 PCSource,ALUOp,ALUSrcB,ALUSrcA,RegWrite,RegDst,Zero,Overflow,
		 Clock);

   //Debugging output variables
   output [31:0] Cycle,PCReg,ALUOutReg,RegA,RegB,Instruction;

   output [5:0]  Opcode;
   output 	 Zero,Overflow;
   input 	 PCWriteCond,PCWrite,IorD,MemRead,MemWrite,IRWrite,
		 ALUSrcA,RegWrite,Clock;
   input [1:0] 	 PCSource,ALUOp,ALUSrcB,RegDst,MemToReg;

   wire [31:0] 	 ExtendedJumpAddr,ExtendedImmediate,ExtendedImmediateShiftLeft2,
		 PC,ALUOut,ReadData1,ReadData2,MemData,Address,MemWriteData,
		 RegWriteData,Op1,Op2;
   wire [25:0] 	 JumpAddr;
   wire [15:0] 	 Immediate;
   wire [5:0] 	 FUNCT;
   wire [4:0] 	 RS,RT,RD,SHAMT,WriteAddr;
   wire [3:0] 	 ALUControl;

   reg [31:0] 	 Cycle,PCReg,ALUOutReg,RegA,RegB,MemDataReg,BranchReg;

   initial
     begin
	PCReg = 0;
	Cycle = 0;
     end

   //Instantiate  Memory   
   Memory memory(MemData,Address,MemWriteData,MemRead,MemWrite,Clock);
   
   //Instantiate Instruction Register 
   InstructionRegister instr_reg(Instruction,JumpAddr,Immediate,Opcode,RS,RT,
				 RD,SHAMT,FUNCT,MemData,IRWrite,Clock);
   
   //Instantiate Register File   
   RegisterFile regfile(ReadData1,ReadData2,RegWriteData,RS,RT,WriteAddr,
			RegWrite,Clock);
   
   //Instantiate ALU   
   ALU alu(ALUOut,Overflow,Zero,Op1,Op2,SHAMT,ALUControl);
   
   //Instantiate ALU COntrol   
   ALUControl alu_control(ALUControl,Opcode,FUNCT,ALUOp);
   
   //Instantiate Muxes 
         //PCSource Mux    
   Mux4to1 PCMux(PC,ALUOut,ALUOutReg,ExtendedJumpAddr,32'bx,PCSource);
         //Select Opreand 2 for ALU    
   Mux4to1 Op2Mux(Op2,RegB,32'd4,ExtendedImmediate,ExtendedImmediateShiftLeft2,
		  ALUSrcB);
         //Set Address for memory    
   assign Address = IorD ? ALUOutReg :PCReg;
         //Set Register File write Address  
   Mux4to1 #(5) WriteAddrMux(WriteAddr,RT,RD,5'b11111,5'bx,RegDst);
         //Select what to write in register file 
   Mux4to1 RegWriteDataMux(RegWriteData,ALUOutReg,MemDataReg,PC,32'd10,MemToReg);
   
         //Select Operand 1 for ALU  
   assign Op1 = ALUSrcA ? RegA : PCReg;

   //Set the PC write control
   assign PCWriteControl =  PCWriteCond | PCWrite;

   //Extend the Jump Address
   assign ExtendedJumpAddr = {PCReg[31:28],JumpAddr,2'b00};

   //Extend Immediate  ---- Sign Extend and Shift left 2
   assign ExtendedImmediate = {{16{Immediate[15]}},Immediate};
   assign ExtendedImmediateShiftLeft2 = {ExtendedImmediate[29:0],2'b00};

   //Write the value of Register B into Memory - for save word instructions
   assign MemWriteData = RegB;


   always @(posedge Clock)
     begin
	Cycle <= Cycle + 1;

	if (PCWriteControl)
	  begin
	     PCReg <= PC;
	  end

	MemDataReg = MemData;
	RegA <= ReadData1;
	RegB <= ReadData2;

	ALUOutReg <= ALUOut;
     end // always @ (posedge Clock)
endmodule // DataPath
