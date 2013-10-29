module RegisterFile
   (ReadData1,ReadData2,WriteData,ReadAddr1,ReadAddr2,WriteAddr,RegWrite,Clock);

   //Port Declarations
   output [31:0] ReadData1,ReadData2;
   input [31:0]  WriteData;
   input [4:0] 	 ReadAddr1,ReadAddr2,WriteAddr;
   input 	 RegWrite,Clock;

   reg [31:0] 	 RegFile [0:31];
   integer 	 i;

   initial
     begin
	for(i=1;i<31;i=i+1)
	  RegFile[i] = i;
     end
   

   //register 0 hardwired to 0
   initial
     begin
	RegFile[0] = 32'd0;
     end

   always @(posedge Clock)
     begin
	if (RegWrite) RegFile[WriteAddr] <= WriteData;
	for(i=0;i<32;i=i+1)
	  $display($time,":reg %d-%d:",i,RegFile[i]);
     end

   assign ReadData1 = (ReadAddr1) ? RegFile[ReadAddr1] : 32'd0;
   assign ReadData2 = (ReadAddr2) ? RegFile[ReadAddr2] : 32'd0;
   
endmodule // RegisterFile
