module uart_top(

  input clk,
  input rst_n,
  
  input  uart_rx,
  
  output uart_tx
   
);

parameter CLK_FREQ = 50000000;
parameter UART_BPS = 115200;


wire         uart_en_w;
wire [7 : 0] uart_data_w;
wire         clk_1m_w;

ip_pll	ip_pll_inst (
	.inclk0 ( clk ),
	.c0 ( clk_1m_w )
	);



uart_rx #(                          //串口接收模块
    .CLK_FREQ       (CLK_FREQ),       //设置系统时钟频率
    .UART_BPS       (UART_BPS))       //设置串口接收波特率
u_uart_x(                 
    .clk        (clk), 
    .rst_n      (rst_n),
    
    .uart_rx_data       (uart_rx),
    .uart_rx_done       (uart_en_w),
    .uart_data          (uart_data_w)
    );
uart_tx  #(
    .CLK_FREQ  (CLK_FREQ),
    .UART_BPS  (UART_BPS))
 u_uart_tx(
    .clk          (clk),
    .rst_n        (rst_n),

    .uart_tx_flag (uart_en_w),
    .uart_data    (uart_data_w),
    .uart_tx_data (uart_tx)
);


endmodule