module Mux4to1 #(parameter N=32) 
   (Output, Input0, Input1, Input2, Input3, Select);

   //Port Declarations
   output reg [N-1:0] Output;
   input [N-1:0]      Input0, Input1, Input2, Input3;
   input [1:0] 	     Select;
   
   always @ (Input0 or Input1 or Input2 or Input3 or Select) 
     begin
        case (Select)
          2'b00: Output = Input0;
          2'b01: Output = Input1;
          2'b10: Output = Input2;
          2'b11: Output = Input3;
        endcase // case (Select)
     end
endmodule // Mux4to1
