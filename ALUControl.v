module ALUControl(ALUControl,Opcode,Func,ALUOp);

   //Port Declarations
   output reg [3:0] ALUControl;
   input [5:0] 	    Func,Opcode;
   input [1:0] 	    ALUOp;

   always @(Func or ALUOp or Opcode)
     begin
	case(ALUOp)
	  2'b00 : ALUControl = 4'b0000;          //ADD
	  2'b01 : ALUControl = 4'b0001;          //SUB
	  2'b10 : begin                          //RTYPE
	     case(Func)
	       6'b000100 : ALUControl = 4'b0000;  //ADD 
	       6'b000110 : ALUControl = 4'b0001;  //SUB 
	       6'b001000 : ALUControl = 4'b0010;  //AND 
	       6'b001001 : ALUControl = 4'b0011;  //OR 
	       6'b001010 : ALUControl = 4'b0100;  //XOR
	       6'b001100 : ALUControl = 4'b0101;  //SLL
	       6'b001110 : ALUControl = 4'b0110;  //SRL 
	       6'b001111 : ALUControl = 4'b0111;  //SRA 
	       6'b010000 : ALUControl = 4'b1000;  //SEQ
	       6'b010010 : ALUControl = 4'b1001;  //SNE
	       6'b010100 : ALUControl = 4'b1010;  //SLT
	       6'b010110 : ALUControl = 4'b1011;  //SLE
	       6'b011000 : ALUControl = 4'b1100;  //SGT
	       6'b011010 : ALUControl = 4'b1101;  //SGE 
	       6'b000000 : ALUControl = 4'b1111;  //NOP
	       default : ALUControl = 4'bxxxx;
	     endcase // case (Func)
	  end // case: 2'b10
	  2'b11 : begin                           //I TYPE
	     case (Opcode)
	       6'b010100 : ALUControl = 4'b0000;   //ADDI
	       6'b010110 : ALUControl = 4'b0001;   //SUBI
	       6'b011000 : ALUControl = 4'b0010;   //ANDI
	       6'b011001 : ALUControl = 4'b0011;   //ORI
	       6'b011010 : ALUControl = 4'b0100;   //XORI
	       6'b011100 : ALUControl = 4'b0101;   //SLLI
	       6'b011110 : ALUControl = 4'b0110;   //SRLI
	       6'b011111 : ALUControl = 4'b0111;   //SRAI
	       6'b100000 : ALUControl = 4'b1000;   //SEQI
	       6'b100010 : ALUControl = 4'b1001;   //SNEI
	       6'b100100 : ALUControl = 4'b1010;   //SLTI
	       6'b100110 : ALUControl = 4'b1011;   //SLEI
	       6'b101000 : ALUControl = 4'b1100;   //SGTI
	       6'b101010 : ALUControl = 4'b1101;   //SGEI
	       6'b011011 : ALUControl = 4'b1110;   //LHI  
	       default : ALUControl = 4'bxxxx;
	     endcase // case (Opcode)
	  end // case: 2'b11
	endcase // case (ALUOp)
     end // always @ (Func or ALUOp or Opcode)
endmodule // ALUControl