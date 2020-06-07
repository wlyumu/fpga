
module led_alarm #(parameter    L_TIME = 25'd25_000_000  // 控制led闪烁时间（此为500ms）
    )(
        //system clock
        input             clk       ,  // 时钟信号
        input             rst_n     ,  // 复位信号

        //led interface
        output   [3:0]    led       ,  // LED 灯

        //user interface
        input             error_flag   // 错误标志
);

//reg define
reg               led_t  ;             // 使用的led灯
reg    [24:0]     led_cnt;             // led计数

//*****************************************************
//**                    main code
//*****************************************************

//led输出
assign  led = {3'b000,led_t};

//错误标志为1时led闪烁，否则，LED0常亮
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        led_cnt <= 25'd0;
        led_t <= 1'b0;
    end
    else begin
        if(error_flag) begin                  // 读到的值错误
            led_cnt <= led_cnt + 25'd1;
            if(led_cnt == L_TIME) begin       // 数据错误时LED灯每隔L_TIME时间闪烁一次
                led_cnt <= 25'd0;
                led_t <= ~led_t;
            end
        end
        else begin                            // 读完且读到的值正确
            led_cnt <= 25'd0;
            led_t <= 1'b1;                    // led灯常亮
        end
    end
end

endmodule
