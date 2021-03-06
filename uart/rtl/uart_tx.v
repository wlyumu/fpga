/*串口发送模块*/
module uart_tx(
    input  clk,
    input  rst_n,

    input          uart_tx_flag,
    input  [7 : 0] uart_data,
    output reg     uart_tx_data
);

parameter  CLK_FREQ  = 50_000_000 ;
parameter  UART_BPS = 115200;
localparam BSP_CNT = CLK_FREQ / UART_BPS;

reg [15 : 0] clk_cnt;
reg [3  : 0] tx_cnt ;
reg [7  : 0] tx_data;
reg          tx_flag;  
      
reg uart_tx_d0;
reg uart_tx_d1;                      

wire   en_flag;
assign en_flag = uart_tx_d0 & (~uart_tx_d1);

/*接收到串口发送信号， 进入发送过程， 上升沿检测*/
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)begin
   uart_tx_d0 <= 1'b0;
   uart_tx_d1 <= 1'b0;
   end
   else begin
       uart_tx_d0 <= uart_tx_flag;
       uart_tx_d1 <= uart_tx_d0;
   end
end

/*进入发送过程, 缓存串口的数据*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
       tx_flag <= 1'd0;
       tx_data <= 8'd0;
    end
    else begin
        if(en_flag)begin
           tx_flag <= 1'b1;
           tx_data <= uart_data;
        end
        else if(tx_cnt == 4'd9 && clk_cnt == (BSP_CNT / 2)  )begin
        tx_flag <= 1'b0;
        tx_data <= 8'd0;
        end
        else begin
        tx_data <= tx_data;
        tx_flag <= tx_flag;
        end
    end
    
end

always @(posedge clk or negedge rst_n)begin
      if(!rst_n)begin
      clk_cnt <= 16'd0;
      tx_cnt  <= 4'd0;
      end
      else begin
        if(tx_flag) begin //发送信号到来时，开始计数
            if(clk_cnt <= BSP_CNT - 1)begin
               clk_cnt <= clk_cnt + 1'd1;
               tx_cnt  <= tx_cnt;
            end
            else begin   //当计数到达BSP_CNT时，即接收完一个bit
               clk_cnt <= 16'd0;
               tx_cnt  <= tx_cnt + 1'd1;
             end
        end
        else begin 
           clk_cnt <= 16'd0;
           tx_cnt  <= 4'd0;
        end
      
      end
end


always @(posedge clk or negedge rst_n)begin
   if(!rst_n)begin
     uart_tx_data <= 1'd1;
   end
   else if(tx_flag)begin
       case(tx_cnt)
           4'd0: uart_tx_data <= 1'b0;         //起始位 
           4'd1: uart_tx_data <= tx_data[0];
           4'd2: uart_tx_data <= tx_data[1];
           4'd3: uart_tx_data <= tx_data[2];
           4'd4: uart_tx_data <= tx_data[3];
           4'd5: uart_tx_data <= tx_data[4];
           4'd6: uart_tx_data <= tx_data[5];
           4'd7: uart_tx_data <= tx_data[6];
           4'd8: uart_tx_data <= tx_data[7];
           4'd9: uart_tx_data <= 1'b1;
           default: ;
        endcase 
   end
   else 
     uart_tx_data <= 1'b1;



end


endmodule // uart_tx