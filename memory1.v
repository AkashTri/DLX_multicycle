// Memory for Multi-cycle Implementation

module Memory(MemData,Address,WriteData,MemRead,MemWrite,Clock);

   // Port Declarations
   output [31:0] MemData;
   input [31:0]  WriteData,Address; 
   input 	 MemRead,MemWrite,Clock;

   reg [7:0] 	 Memory[0:1023];

   initial
     begin
	//J
	{Memory[0],Memory[1],Memory[2],Memory[3]} = 32'b001100_00000000000000000000000011;
	//JAL
	//{Memory[0],Memory[1],Memory[2],Memory[3]} = 32'b001101_00000000000000000000000011;
	//JR
	//{Memory[0],Memory[1],Memory[2],Memory[3]} = 32'b001101_00000000000000000000000101;
	//JALR
	//{Memory[0],Memory[1],Memory[2],Memory[3]} = 32'b001101_00000000000000000000001001;
	//BEQ
	//{Memory[0],Memory[1],Memory[2],Memory[3]} = 32'b010000_10001_10010_0000000000000010;
	//BNEQ
	//{Memory[0],Memory[1],Memory[2],Memory[3]} = 32'b010001_10001_10010_0000000000010000;
	//ADD
	//{Memory[0],Memory[1],Memory[2],Memory[3]} = 32'b000000_10000_10010_00001_00000_000100;
	//LWI
	{Memory[4],Memory[5],Memory[6],Memory[7]} = 32'b000100_00010_00010_0000000000000001;
	//SW
	{Memory[8],Memory[9],Memory[10],Memory[11]} = 32'b000000_10001_10010_00001_00000_101000;
	

	//ADD Rd,Rs1,Rs2 000000 10001 10010 00001 00000 000100
	{Memory[12],Memory[13],Memory[14],Memory[15]} = 32'b000000_10000_10010_00001_00000_000100;
	//SUB Rd,Rs1,Rs2 000000 10001 10010 00001 00000 000110
	{Memory[16],Memory[17],Memory[18],Memory[19]} = 32'b000000_10001_10010_00001_00000_000110;
	//AND Rd,Rs1,Rs2 000000 10001 10010 00001 00000 001000
	{Memory[20],Memory[21],Memory[22],Memory[23]} = 32'b000000_10001_10010_00001_00000_001000;
	//OR  Rd,Rs1,Rs2 000000 10001 10010 00001 00000 001001
	{Memory[24],Memory[25],Memory[26],Memory[27]} = 32'b000000_10001_10010_00001_00000_001001;

	{Memory[40],Memory[41],Memory[42],Memory[43]} = 32'b000000_10001_10010_00001_00000_001001;
	{Memory[44],Memory[45],Memory[46],Memory[47]} = 32'b000000_10001_10010_00001_00000_001001;
	{Memory[48],Memory[49],Memory[50],Memory[51]} = 32'b000000_10001_10010_00001_00000_001001;
     end // initial begin

   // Read from memory
   assign MemData = MemRead ? {Memory[Address],Memory[Address+1],Memory[Address+2],Memory[Address+3]} :0;

   //Write to memory
   always @ (posedge Clock) 
     begin
	if (MemWrite) 
	  begin
	     Memory[Address] <= WriteData; 
	  end
     end
endmodule // Memory
