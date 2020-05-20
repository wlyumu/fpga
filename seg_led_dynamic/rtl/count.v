//计数器模块
module count(    

    input  clk,
    input  rst_n,

    output reg[19 : 0]  data,   // 6个数码管都要显示
    output reg[ 5 : 0]  point, //  小数点位置
    output reg          en   , // 数码管显示使能信号
    output reg          sign  // 符号位
    
);


parameter MAX_NUM = 23'd5_000_000; // 最大计时10ms
reg [22 : 0]cnt;
reg         flag;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
    cnt <= 22'd0;
    flag <= 1'b0;
    end
    else begin
        if(cnt < MAX_NUM - 1)begin
        cnt  <= cnt + 1;
        flag <= 1'b0;
        end
        else begin
        cnt <= 23'd0;
        flag <= 1'b1;
        end
    end

    
end

//将数码管显示的数累加
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
       data <= 20'd0;
       point <= 6'b000_000;
       en    <= 1'b0;
       sign  <= 1'b0;
    end
    else begin
        point <= 6'b000_000;  // 默认不显示小数点
        sign <=  1'd0;        // 显示数值
        en   <=  1'd1;       //  打开数码管是能信号
        if(flag )begin
            if(data <= 20'd999_999)
              data <= data + 1;
            else
              data <= 20'd0;
            
        end

    end
    
end

endmodule // count
