// Control Unit Multicycle
module Control(RegDst,RegWrite,ALUSrcA,MemRead,MemWrite,MemtoReg,IorD,IRWrite,
	       PCWrite,PCWriteCond,ALUOp,ALUSrcB,PCSource,Opcode,Func,Zero,
	       Overflow,Clock,State);

   //Port Declarations
   output reg RegWrite,ALUSrcA,MemRead,MemWrite,IorD,IRWrite,
	      PCWrite,PCWriteCond;
   output reg [1:0] PCSource,ALUOp,ALUSrcB,RegDst,MemtoReg;
   input [5:0] 	    Opcode,Func;
   input 	    Clock,Zero,Overflow;
   output reg [3:0] 	    State;

   // State Encoding
   parameter InstrFetch       = 4'b0000;
   parameter InstrDecode      = 4'b0001;
   parameter ComputeAddrI     = 4'b0010;
   parameter MemReadAccess    = 4'b0011;
   parameter WriteBack        = 4'b0100;
   parameter MemWriteAccess   = 4'b0101;
   parameter Execution        = 4'b0110;
   parameter RTypeCompletion  = 4'b0111;
   parameter BranchCompletion = 4'b1000;
   parameter JumpLink         = 4'b1001;
   parameter JumpCompletion   = 4'b1010;
   parameter ImmCompletion    = 4'b1011;
   parameter ComputeImm       = 4'b1100;
   parameter JumpRegister     = 4'b1101;
   parameter ComputeAddrR     = 4'b1110;
   

   //OpCode constants
   parameter RTYPE = 6'b000000;
   parameter ADDI  = 6'b010100;
   parameter SUBI  = 6'b010110;
   parameter ANDI  = 6'b011000;
   parameter ORI   = 6'b011001;
   parameter XORI  = 6'b011010;
   parameter SLLI  = 6'b011100;
   parameter SRLI  = 6'b011110;
   parameter SRAI  = 6'b011111;
   parameter LHI   = 6'b011011;
   parameter SEQI  = 6'b100000;
   parameter SNEI  = 6'b100010;
   parameter SLTI  = 6'b100100;
   parameter SLEI  = 6'b100110;
   parameter SGTI  = 6'b101000;
   parameter SGEI  = 6'b101010;
   parameter BEQ  = 6'b010000;
   parameter BNEQ  = 6'b010001;
   parameter J     = 6'b001100;
   parameter JAL   = 6'b001101;
   parameter JR    = 6'b001110;
   parameter JALR  = 6'b001111;
   parameter LWI   = 6'b000100;
   parameter SWI   = 6'b001000;

   //Function constants  (for non-ALU instructions)
   parameter LW = 6'b100000;
   parameter SW = 6'b101000;
   
   // Sequential Logic
   always @(posedge Clock)
     begin
	case(State)
	  InstrFetch  : State <= InstrDecode;
	  InstrDecode : begin
	     case (Opcode)
	       RTYPE : begin
		  case (Func)
		    LW : State <= ComputeAddrR;
		    SW : State <= ComputeAddrR;
		    default : State <= Execution;
		  endcase // case (Func)
	       end // case: RTYPE
	       BEQ : State <= BranchCompletion;
	       BNEQ : State <= BranchCompletion;
	       J : State <= JumpCompletion;
	       JAL : State <= JumpLink;
	       JR : State <= JumpRegister;
	       JALR : State <= JumpLink;
	       LWI : State <= ComputeAddrI;
	       SWI : State <= ComputeAddrI;
	       ADDI : State <= ComputeImm;
	       SUBI : State <= ComputeImm;
	       ANDI : State <= ComputeImm;
	       ORI : State <= ComputeImm;
	       XORI : State <= ComputeImm;
	       SLLI : State <= ComputeImm;
	       SRLI : State <= ComputeImm;
	       SRAI : State <= ComputeImm;
	       LHI : State <= ComputeImm;
	       SEQI : State <= ComputeImm;
	       SNEI : State <= ComputeImm;
	       SLTI : State <= ComputeImm;
	       SLEI : State <= ComputeImm;
	       SGTI : State <= ComputeImm;
	       SGEI : State <= ComputeImm;
	     endcase // case (Opcode)
	  end // case: InstrDecode
	  
	  ComputeAddrR : begin
	     case (Opcode)
	       LW : State <= MemReadAccess;
	       SW : State <= MemWriteAccess;
	     endcase // case (Opcode)
	  end

	  ComputeAddrI : begin
	     case (Opcode)
	       LWI : State <= MemReadAccess;
	       SWI : State <= MemWriteAccess;
	     endcase // case (Opcode)
	  end

	  JumpLink : begin
	     case (Opcode)
	       JAL : State <= JumpCompletion;
	       JALR : State <= JumpRegister;
	     endcase // case (Opcode)
	  end
	  
	  ComputeImm : State <= ImmCompletion;
	  Execution : State <= RTypeCompletion;
	  BranchCompletion : State <= InstrFetch;
	  JumpCompletion : State <= InstrFetch;
	  JumpRegister : State <= InstrFetch;
	  ImmCompletion : State <= InstrFetch;
	  RTypeCompletion : State <= InstrFetch;	  
	  MemReadAccess : State <= WriteBack;
	  MemWriteAccess : State <= InstrFetch;
	  WriteBack : State <= InstrFetch;
	  default : State <= InstrFetch;
	endcase // case (State)
     end // always @ (posedge Clock)

   //Combinational Logic
   always @(State)
     begin
	//we want everything to be zero if it is not explicitly set in 
	// each state
	RegDst = 1'b0;
	RegWrite = 1'b0;
	ALUSrcA = 1'b0;
	MemRead = 1'b0;
	MemWrite = 1'b0;
	MemtoReg = 1'b0;
	IorD = 1'b0;
	IRWrite = 1'b0;
	PCWrite = 1'b0;
	PCWriteCond = 1'b0;
	ALUOp = 2'b00;
	ALUSrcB = 2'b00;
	PCSource = 2'b00;

	case (State)
	  InstrFetch : begin
	     //Read Instruction into Instruction Register
	     IorD = 1'b0;              //select PC
	     MemRead = 1'b1;           //read memory
	     IRWrite = 1'b1;           //write IR
	     //Increment PC, PC+4->PC
	     ALUSrcA = 1'b0;           //select PC into ALU
	     ALUSrcB = 2'b01;          //select constant 4
	     ALUOp = 2'b00;            //ALU adds
	     PCSource = 2'b00;         //select ALU output
	     PCWrite = 1'b1;           //write PC
	  end // case: InstrFetch

	  InstrDecode : begin
	     //Control unit decodes instruction
	     //Datapath prepares for execution
	     //R and I types,reg1->Areg,reg2->Breg -- No control signals needed
	     //Branch type,compute branch address in ALUOut
	     ALUSrcA = 1'b0;           //select PC into ALU
	     ALUSrcB = 2'b11;          //Instr. bits 0-15 shift 2 into ALU
	     ALUOp = 2'b00;            //ALU adds
	  end

	  ComputeAddrI : begin
	     //I type,lw or sw: compute memory address in 
	     // ALUOut<-Areg+sign extend IR[0-15]
	     ALUSrcA = 1'b1;           //A reg into ALU
	     ALUSrcB = 2'b10;          //Instr. Bits 0-15 into ALU
	     ALUOp = 2'b00;            //ALU adds
	  end

	  ComputeAddrR : begin
	     //Compute memory address for R type load save
	     ALUSrcA = 1'b1;           //A reg into ALU
	     ALUSrcB = 2'b00;          //B reg into ALU
	     ALUOp   = 2'b00;          //ALU adds
	  end

	  ComputeImm : begin
	     ALUSrcA = 1'b1;
	     ALUSrcB = 2'b10;
	     ALUOp   = 2'b11;
	  end

	  MemReadAccess : begin
	     IorD = 1'b1;              //select ALUOut into memory address
	     MemRead = 1'b1;           //read memory to MDR
	  end

	  MemWriteAccess : begin
	     IorD = 1'b1;              //select ALUOut into memory address
	     MemWrite = 1'b1;          //write memory
	  end

	  WriteBack : begin
	     RegDst = 2'b00;            //instr. bits 16-20 are write reg
	     MemtoReg = 2'b01;          //MDR to reg file write input
	     RegWrite = 1'b1;          //read memory to MDR
	  end

	  ImmCompletion : begin
	     RegWrite = 1'b1;
	     RegDst = 2'b00;
	     MemtoReg = 2'b00;
	  end

	  Execution : begin
	     ALUSrcA <= 1'b1;           //A reg into ALU
	     ALUSrcB <= 2'b00;          //B reg into ALU
	     ALUOp <= 2'b10;            //instr. bits 0-5 control ALU
	  end

	  RTypeCompletion : begin
	     RegWrite <= 1'b1;          //write register
	     RegDst <= 2'b01;            //Instr. bits 11-15 specify reg.
	     MemtoReg <= 2'b00;          //ALUOut into reg.
	  end

	  BranchCompletion : begin
	     ALUSrcA <= 1'b1;            //A reg into ALU  
	     ALUSrcB <= 2'b00;           //B reg into ALU
	     ALUOp <= 2'b01;             //ALU subtracts
	     case (Opcode)
	       BEQ : begin
		  if (Zero == 1'b1) PCSource <= 2'b01; //ALUOut to PC
		  if (Zero == 1'b1) PCWriteCond = 1'b1; //write PC
	       end
	       BNEQ: begin
		  if (Zero == 1'b0) PCSource <= 2'b01; //ALUOut to PC
		  if (Zero == 1'b0) PCWriteCond = 1'b1; //write PC
	       end
	     endcase // case (Opcode)
	  end // case: BranchCompletion

	  JumpLink : begin
	     RegDst <= 2'b10;
	     MemtoReg <= 2'b10;
	     RegWrite <= 1'b1;
	  end
	  
	         
          JumpCompletion: begin
             PCWrite = 1;
             PCSource = 2'b10;
          end

	  JumpRegister : begin
	     ALUSrcA <= 1'b1;           //A reg into ALU
	     ALUSrcB <= 2'b00;          //B reg into ALU
	     ALUOp <= 2'b00;            //ALU adds
	     PCSource <= 2'b00;         //ALU OUT to PC
	     PCWrite = 1'b1;            //write PC
	  end
	 
        endcase // case (State)
     end // always @ (State)
endmodule // Control

