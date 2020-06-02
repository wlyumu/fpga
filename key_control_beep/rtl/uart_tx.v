
/*串口发送模块*/
module uart_tx(
    input  clk,
    input  rst_n,

    input          uart_tx_flag,
    input  [7 : 0] uart_data,
    output reg     uart_tx_data;
);

parameter  CLK_CNT  = 50_000_000 ;
parameter  UART_BSP = 115200;
localparam BSP_CNT = CLK_CNT / UART_BSP;

reg [15 : 0] clk_cnt;
reg [3  : 0] tx_cnt ;
reg          
reg uart_tx_d0;
reg uart_tx_d1;
assign uart_tx_flag = uart_tx_d0 & (~uart_tx_d1);

/*接收到串口发送信号， 进入发送过程， 上升沿检测*/
always @(posedge clk or negedge rst_n) begin
   if(!rst_n)begin
   uart_tx_d0 <= 1'd0;
   uart_tx_d1 <= 1'd0;
   end
   else begin
       uart_tx_d0 <= uart_tx_flag;
       uart_tx_d1 <= uart_tx_d0;
   end
end

/*进入发送过程*/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin

    end
    
end

endmodule // uart_tx