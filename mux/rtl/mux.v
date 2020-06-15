module mux(

input   in1,
input   in2,

input   sel,
output  reg out

);

/*
   当sel = 0时，多路选择器输出为in2;
	当Sel = 1时，多路选择器输出为in1;

*/
always @(*)begin

//case 语句实现MUX
//   case(sel)
//	   1'b0: out <= in2;
//	   2'b1: out <= in1;
//	   default : out <= in1;
//	endcase

//  if语句实现MUX
//   if(sel)
//	  out <= in2;
//	else
//	  out <= in1;

// 三目运算符
   out = sel ? in2 : in1;
end
endmodule