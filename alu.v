// ALU Implementation
module ALU #(parameter N = 32) (out,ov,zero,in1,in2,SHAMT,control);

   //Port Declarations
   input [N-1:0] in1,in2;
   input [3:0] 	 control;
   input [4:0] 	 SHAMT;
   output reg [N-1:0] out;
   output    reg      ov,zero;
   reg 		      carry;
   

   always@(in1 or in2 or control)
     begin
	case (control)
	  4'b0000 : begin                           //ADD
	     {carry,out} = in1 + in2;
	     ov =(~in1[N-1]&~in2[N-1]&out[N-1]) | (in1[N-1]&in2[N-1]&~out[N-1]);
	  end
	  4'b0001 : begin                           //SUBTRACT
	     {carry,out} = in2 - in1;
	     ov = carry^({carry,out[N-1]} - in1[N-1] - in2[N-1]);
	  end
	  4'b0010 : out = in1 & in2;                //AND
	  4'b0011 : out = in1 | in2;                //OR
	  4'b0100 : out = in1 ^ in2;                //XOR
	  4'b0101 : out = in1 << in2[4:0];          //SLL
	  4'b0110 : out = in1 >> in2[4:0];          //SRL
	  4'b0111 : out = in1 >>> in2[4:0];         //SRA
	  4'b1000 : out = (in1==in2) ? 32'd1 : 32'd0;//SEQ
	  4'b1001 : out = (in1!=in2) ? 32'd1 : 32'd0;//SNE
	  4'b1010 : out = (in1<in2)  ? 32'd1 : 32'd0;//SLT
	  4'b1011 : out = (in1>=in2) ? 32'd1 : 32'd0;//SLE
	  4'b1100 : out = (in1>in2)  ? 32'd1 : 32'd0;//SGT
	  4'b1101 : out = (in1>=in2) ? 32'd1 : 32'd0;//SGE
 	  4'b1110 : out = {in2, 16'd0};              //LHI
	  4'b1111 : ;                                //NOP             
	  default : out = 32'bx;
	endcase // case (control)
	assign zero = (out == 0);
     end // always@ (in1 or in2 or control)
endmodule // ALU
