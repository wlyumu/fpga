module seg_led_static_top
(

  input clk,
  input rst_n,
  
  
  output [5 : 0] sel,    //数码管的片选信号
  output [7 : 0] sel_led //数码管的段选信号

);


parameter TIME_DELAY = 25'd25_000_000;


wire add_flag;    //数码管显示加一信号

//例化时钟信号，每隔0.5产生一个时钟周期信号
timer_count #
(
  .MAX_CNT_NUM  (TIME_DELAY)
)u_timer_count(
  .clk   (clk    ),
  .rst_n (rst_n  ),
  .cnt_flag  (add_flag)
);

//数码管控制
seg_led_static u_seg_led_static(
    .clk        (clk     ), 
    .rst_n      (rst_n   ),

    .add_flag   (add_flag),           
    
    .sel        (sel     ),     
    .seg_led    (sel_led )
);

endmodule