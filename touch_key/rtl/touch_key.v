module touch_key(
    input sys_clk,
    input sys_rst_n,
    input touch_key,

    output reg  led_out
);

reg touch_key1;
reg touch_key2;
reg touch_flag;

always @(posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)begin
        touch_key1 <= 1'b0;
        touch_key2 <= 1'b0;
    end
    else begin
        touch_key1 <= touch_key;
        touch_key2 <= touch_key1;
    end
end

always @(posedge sys_clk or negedge sys_rst_n ) begin
    if(!sys_rst_n)
       touch_flag <= 0;
    else if(touch_key1 == 1'b0 && touch_key2 == 1'b1)
       touch_flag <= 1'b1;
    else 
       touch_flag <= 1'b0; 
end

always@(posedge sys_clk or negedge sys_rst_n)begin
    if(!sys_rst_n)
      led_out <= 1'b0;
    else if(touch_flag == 1'b1)
      led_out <= ~led_out;
    else
      led_out <= led_out;
end

endmodule // touch_key