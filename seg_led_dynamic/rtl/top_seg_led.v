module top_seg_led(

    input   clk,
    input   rst_n,

    output  [5 : 0] seg_sel,
    output  [7 : 0] seg_led
    
);
//wire define
wire    [19:0]  data;                 // 数码管显示的数值
wire    [ 5:0]  point;                // 数码管小数点的位置
wire            en;                   // 数码管显示使能信号
wire            sign;                 // 数码管显示数据的符号位

count  u_count(    

    .clk    (clk),
    .rst_n  (rst_n),

    .data   (data),   
    . point (point), 
    . en    (en   ), 
    . sign  (sign ), 
    
);

seg_led  u_seg_led(
    .clk   (clk),
    .rst_n (rst_n),
      
    .data  (data),
    .point (point),
    .en    (en),
    .sign  (sign),

    .seg_sel (seg_sel), // 数码管的位选信号
    .seg_led (seg_led)// 数码管的段选信号
 );

endmodule // top_sel_led