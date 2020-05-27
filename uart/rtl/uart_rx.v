module uart_rx(

    input               clk,
    input               rst_n,
    
    input               uart_rx_data,
    
    output  reg [7 : 0] uart_data,
    output  reg         uart_rx_done 
);

parameter   CLK_FREQ   = 50000000;
parameter   UART_BPS  = 115200;
localparam  BPS_CNT   = CLK_FREQ / UART_BPS;

reg [15 : 0] clk_cnt;  /*时间计数器*/
reg [3  : 0] rx_cnt;   /*接收数据计数器*/
reg [ 7 : 0] rxdata;   /*数据缓冲区*/

reg rx_flag;           /*接收信号*/

reg uart_rx_d0;
reg uart_rx_d1;

wire       start_flag;
assign  start_flag = uart_rx_d1 & (~uart_rx_d0);  


/*捕获接收信号 ---- 下降沿*/
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
    uart_rx_d0 <= 1'b0;
    uart_rx_d1 <= 1'b0;
    end
    else begin
       uart_rx_d0 <= uart_rx_data;
       uart_rx_d1 <= uart_rx_d0;    
    end

end
  

//对UART接收端口的数据延迟两个时钟周期

/*开始信号到来,进入接收流程*/
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
     rx_flag <= 1'b0;
   else begin
     if(start_flag)
       rx_flag <= 1'b1;
      else if((rx_cnt == 4'd9) && (clk_cnt == BPS_CNT/2)) /*接收9个bit数据*/
       rx_flag <= 1'b0;
      else
       rx_flag <= rx_flag;
   end

end


/*进入接收阶段*/
always @(posedge clk or negedge rst_n)begin
     if(!rst_n) begin
      clk_cnt <= 16'd0;
      rx_cnt  <= 4'd0 ;
     end 
     else if(rx_flag)begin
        if(clk_cnt < BPS_CNT - 1)begin
           clk_cnt <= clk_cnt + 1'd1;
           rx_cnt  <= rx_cnt;
        end
        else begin
          clk_cnt <= 16'd0;
          rx_cnt <= rx_cnt + 1'd1;
        end
     end
     else begin
        clk_cnt <= 16'd0;
        rx_cnt  <= 4'd0;
     end

end

/*将接收的数据寄存起来*/
always @(posedge clk or negedge rst_n)begin
  if(!rst_n)
  rxdata <= 8'd0;
  else if(rx_flag)begin
      if(clk_cnt == BPS_CNT / 2)begin
         /*根据数据计数器，将接收到的数据存入相应的地方*/
         case(rx_cnt)
         4'd1: rxdata[0] <= uart_rx_d1;
         4'd2: rxdata[1] <= uart_rx_d1;
         4'd3: rxdata[2] <= uart_rx_d1;
         4'd4: rxdata[3] <= uart_rx_d1;
         4'd5: rxdata[4] <= uart_rx_d1;
         4'd6: rxdata[5] <= uart_rx_d1;
         4'd7: rxdata[6] <= uart_rx_d1;
         4'd8: rxdata[7] <= uart_rx_d1;
         default: ;
         endcase
      
      end
      
      else 
      rxdata <= rxdata;
    end
    else 
      rxdata <= 8'd0;
end

/*置接收完成标志，并将数据缓存出去*/
always @(posedge clk or negedge rst_n)begin
    if(!rst_n )begin
    uart_data <= 8'd0;
    uart_rx_done <= 1'b0;
    end
    else if(rx_cnt == 4'd9)begin
       uart_data <= rxdata;
       uart_rx_done <= 1'b1;
    end
    else begin
       uart_data <= 8'd0;
       uart_rx_done <= 1'b0;
    end 
      

end
endmodule