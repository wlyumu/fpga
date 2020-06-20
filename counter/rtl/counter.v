module counter
#(parameter CNT_MAX = 25'd24_999_999)
(
    input sys_clk,
	 input sys_rst,
	 
	 output reg led_out 
);


reg [24 : 0] cnt;

always @(posedge sys_clk or negedge sys_rst)begin

    if(!sys_rst)
	   cnt <= 25'd0;
	 else if(cnt == CNT_MAX)
	   cnt <= 25'd0;
    else
	   cnt <= cnt + 1'd1;
end


always @(posedge sys_clk or negedge sys_rst)begin
    if(!sys_rst)
	   led_out <= 1'b0;
    else if(cnt == CNT_MAX)
	   led_out <= ~led_out;
    else 
	   led_out <= led_out;
end
endmodule
