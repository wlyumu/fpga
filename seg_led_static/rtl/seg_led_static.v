module seg_led_static(
    input   clk,
    input rst_n,

    input  add_flag,            //接收计数器计满信号
    
    output reg [5 : 0] sel,     //片选信号
    output reg [7 : 0] seg_led //段选信号
);

reg [3 : 0]num;                 // 数码管显示十六进制数


//使一上电后就使能数码管
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    sel <= 6'b111_111;
    else
    sel <= 6'b000_000;
    
end

//每次加一信号来时，数码管显示的十六进制数加一
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    num <= 4'h0;
    else if(add_flag) begin
        if(num < 4'hf)     //接收到信号时，如果num < f，即加一，num >= f,即num = 0
        num <= num + 1'd1;
        else
        num <= 4'h0;
    end
    else
        num <= num; 
    
end

//显示数码管
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
    seg_led <= 8'b0;
    else begin
        case (num)
            4'h0 :    seg_led <= 8'b1100_0000;
            4'h1 :    seg_led <= 8'b1111_1001;
            4'h2 :    seg_led <= 8'b1010_0100;
            4'h3 :    seg_led <= 8'b1011_0000;
            4'h4 :    seg_led <= 8'b1001_1001;
            4'h5 :    seg_led <= 8'b1001_0010;
            4'h6 :    seg_led <= 8'b1000_0010;
            4'h7 :    seg_led <= 8'b1111_1000;
            4'h8 :    seg_led <= 8'b1000_0000;
            4'h9 :    seg_led <= 8'b1001_0000;
            4'ha :    seg_led <= 8'b1000_1000;
            4'hb :    seg_led <= 8'b1000_0011;
            4'hc :    seg_led <= 8'b1100_0110;
            4'hd :    seg_led <= 8'b1010_0001;
            4'he :    seg_led <= 8'b1000_0110;
            4'hf :    seg_led <= 8'b1000_1110;
            default:  seg_led <= 8'b1100_0000;
                     
        endcase
    end

    
end

endmodule // seg_led_static