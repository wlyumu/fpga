module flip_flop(
    input  sys_clk,
	 input  sys_rst_n,
	 input  key_in,
    
	 output reg led_out
);



//always @(posedge sys_clk)begin//同步复位
//	if(sys_rst_n == 1'b0)
//	   led_out <= 1'b0;
//	else
//	  led_out <= key_in;
//end

always @(posedge sys_clk or negedge sys_rst_n)begin//异步复位
	if(sys_rst_n == 1'b0)
	   led_out <= 1'b0;
	else
	  led_out <= key_in;
end

endmodule
