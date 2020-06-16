module full_adder(

  input in1,
  input in2,
  input cin,
  
  output sum,
  output cout  /*进位信号*/

);

wire h0_sum;
wire h0_cout;
wire h1_cout;

assign cout = h0_cout || h1_cout;

 half_adder   half_adder_ins01(

    .in1     (in1),
	 .in2     (in2),
	 
	 .sum     (h0_sum),   /*in1 , in2 累加和*/
	 .cout    (h0_cout)   /*in1 , in2 进位信息*/
);

half_adder   half_adder_ins02(

    .in1     (h0_sum),
	 .in2     (cin),
	 
	 .sum     (sum),   /*in1 , in2 累加和*/
	 .cout    (h1_cout)   /*in1 , in2 进位信息*/
);



endmodule