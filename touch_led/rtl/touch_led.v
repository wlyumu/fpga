module touch_led(
    input clk,
    input rst_n,

    input touch_key,  //触摸按键的输出信号
    output reg led     
);

reg touch_key_d0;
reg touch_key_d1;

wire touch_key_flag;


/*上升沿检测*/
assign touch_key_flag = (~touch_key_d1) & touch_key_d0;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        touch_key_d0 <= 1'b0;
        touch_key_d1 <= 1'b1;
    end
    else begin
        /*touch_key_d0 缓存touch_key*/
        touch_key_d0 <= touch_key;
        /*touch_key_d1 滞后一个系统时钟周期缓存touch_key*/
        touch_key_d1 <= touch_key_d0;
    end
    
end


/*led控制模块*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    led <= 1'b0;
    else begin
        if(touch_key_flag)
          led <= ~led;
        else
          led <= led;
    end
    
end
endmodule // touch_led。
