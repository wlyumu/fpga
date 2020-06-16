module  half_adder(

    input in1,
	 input in2,
	 
	 output        sum,   /*in1 , in2 累加和*/
	 output        cout   /*in1 , in2 进位信息*/
);

assign {cout, sum} = in1 + in2;



endmodule