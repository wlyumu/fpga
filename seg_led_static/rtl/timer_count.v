module timer_count(
    input      clk,
    input    rst_n,

    output reg cnt_flag  //计数信号，计数计满产生信号
    
);


parameter  MAX_CNT_NUM = 25_000_000;

reg [24 : 0]  cnt;   // 时钟计数器

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
    cnt <= 25'd0;
    cnt_flag <= 1'd0;
    end
    else begin
        if(cnt < MAX_CNT_NUM)begin
        cnt <= cnt + 1'd1;
        cnt_flag <= 1'b0;
        end
        else begin
        cnt <= 25'd0;
        cnt_flag <= 1'b1;
        end
    end
    
end

endmodule // timer_count