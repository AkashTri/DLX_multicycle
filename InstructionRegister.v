module InstructionRegister(Instruction, JumpAddr, Immediate, OpCode, RS, RT,
			   RD, SHAMT, FUNCT, MemData, IRWrite, Clock);
    output [31:0] Instruction;
    output [25:0] JumpAddr;
    output [15:0] Immediate;
    output [5:0] OpCode, FUNCT;
    output [4:0] RS, RT, RD, SHAMT;
    input [31:0] MemData;
    input IRWrite, Clock;
    
    reg [31:0] Instruction;
    
    always @ (posedge Clock) 
      begin
         if (IRWrite) begin
            Instruction <= MemData;
         end
      end
    
    assign OpCode = Instruction[31:26];
    assign RS = Instruction[25:21];
    assign RT = Instruction[20:16];
    assign RD = Instruction[15:11];
    assign SHAMT = Instruction[10:6];
    assign FUNCT = Instruction[5:0];
    assign Immediate = Instruction[15:0];
    assign JumpAddr = Instruction[25:0];
endmodule
