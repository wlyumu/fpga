module lcd(

   input  clk,
   input  rst_n,
   
   output  lcd_de,      /*RGB LCD数据使能*/
   output  lcd_hs,      /*RGB LCD行同步*/
   output  lcd_vs,      /*RGB LCD场同步*/
   output  lcd_pclk,    /*RGB LCD时钟*/
   output  lcd_bl,      /*RGB LCD背光*/
   output  lcd_rst,     /*RGB LCD复位*/ 
   
   output [15 : 0] lcd_rgb_data/*RGB 565数据*/
);

wire lcd_pclk_w;
wire pll_locked_w;
wire lcd_rst_w ;

wire [15 : 0] lcd_piexl_data;
wire [10 : 0] lcd_piexl_xpos;
wire [10 : 0] lcd_piexl_ypos;

assign lcd_rst_w = rst_n & pll_locked_w;

/*时钟分频 33.3MHZ, 锁相环 areset 高电平复位*/
pll	pll_inst (
	.areset ( ~rst_n     ),
	.inclk0 ( clk        ),
	.c0     ( lcd_pclk_w ),
	.locked ( pll_locked_w ) /*这个locked信号在pll复位后先输出几个时钟周期的低电平，然后pll稳定后就会变为高电平*/
	);

lcd_driver u_lcd_driver
(
   .clk    (lcd_pclk_w),
   .rst_n  (lcd_rst_w), 

   .lcd_de   (lcd_de   ),                  /*RGB LCD数据使能*/
   .lcd_hs   (lcd_hs   ),                  /*RGB LCD行同步*/
   .lcd_vs   (lcd_vs   ),                  /*RGB LCD场同步*/
   .lcd_pclk (lcd_pclk ),                  /*RGB LCD时钟*/
   .lcd_bl   (lcd_bl   ),                  /*RGB LCD背光*/
   .lcd_rst  (lcd_rst  ),                  /*RGB LCD复位*/ 

   .lcd_rgb_data (lcd_rgb_data),           /*RGB 565数据*/

   .pixel_data   (lcd_piexl_data),        /*像素点数据*/
   .pixel_xpos   (lcd_piexl_xpos),        /*像素点横坐标*/
   .pixel_ypos   (lcd_piexl_ypos)        /*像素点纵坐标*/

);

lcd_disp    u_lcd_disp(
   . clk   (lcd_pclk_w),
	. rst_n (lcd_rst_w),
	
   .pixel_data   (lcd_piexl_data),        /*像素点数据*/
   .pixel_xpos   (lcd_piexl_xpos),        /*像素点横坐标*/
   .pixel_ypos   (lcd_piexl_ypos)        /*像素点纵坐标*/

);

endmodule