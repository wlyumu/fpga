module lcd_driver
(
   input  clk,
   input  rst_n,
   
   output  lcd_de,      /*RGB LCD数据使能*/
   output  lcd_hs,      /*RGB LCD行同步*/
   output  lcd_vs,      /*RGB LCD场同步*/
   output  lcd_pclk,    /*RGB LCD时钟*/
   output  lcd_bl,      /*RGB LCD背光*/
   output  lcd_rst,     /*RGB LCD复位*/ 
   
   output [15 : 0] lcd_rgb_data,/*RGB 565数据*/
   
   input  [15 : 0] pixel_data,  /*像素点数据*/
   output [10 : 0] pixel_xpos,  /*像素点横坐标*/
   output [10 : 0] pixel_ypos   /*像素点纵坐标*/

);

/*行时序参数*/
parameter  H_SYNC = 11'd41;   /*行同步*/
parameter  H_BACK = 11'd2 ;   /*行显示后沿*/
parameter  H_DISP = 11'd480;  /*行有效数据*/
parameter  H_FRONT= 11'd2  ;  /*行显示前沿*/
parameter  H_TOTAL= 11'd525;  /*行显示周期*/

/*帧时序参数*/
parameter  V_SYNC = 11'd10;   /*场同步*/
parameter  V_BACK = 11'd2 ;   /*场显示后沿*/
parameter  V_DISP = 11'd272;  /*场有效数据*/ 
parameter  V_FRONT= 11'd2  ;  /*场显示前沿*/
parameter  V_TOTAL= 11'286 ;  /*场显示周期*/

reg [10 : 0] cnt_h;
reg [10 : 0] cnt_v;

wire lcd_en;
wire data_req;
         
assign lcd_bl  = 1'd1;
assign lcd_rst = 1'd1;  /*1: 处于不复位状态，0：处于复位状态*/ 
assign lcd_de  = lcd_en;
assign lcd_hs  = 1'd1;
assign lcd_vs  = 1'd1;


/*使能信号*/
assign lcd_en = ((cnt_h >= H_SYNC + H_BACK) && (cnt_h <= H_SYNC + H_BACK + H_DISP)) &&
                 ((cnt_v >= V_SYNC + V_BACK) && (cnt_v <= V_SYNC + V_BACK + V_DISP))
                 ? 1'b1 : 1'b0;
/*RGB数据输出*/                 
assign lcd_rgb_data = lcd_en ? pixel_data : 0;

/*RGB数据输入请求*/
assign data_req = ((cnt_h >= H_SYNC + H_BACK - 1'b1) && (cnt_h <= H_SYNC + H_BACK + H_DISP -1'b1)) &&
                 ((cnt_v >= V_SYNC + V_BACK - 1'b1) && (cnt_v <= V_SYNC + V_BACK + V_DISP - 1'b1))
                 ? 1'b1 : 1'b0;
assign pixel_xpos = data_req ? (cnt_h - (H_SYNC + H_BACK - 1'b1)) : 11'd0;
assign pixel_ypos = data_req ? (cnt_v - (V_SYNC + V_BACK - 1'b1)) : 11'd0;

/*cnt_h计数器*/
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
      cnt_h <= 10'd0;
     else begin
      if(cnt_h <= H_TOTAL - 1)
         cnt_h <= 10'd0;
      else 
         cnt_h <= cnt_h + 1'd1;
     end

end

/*cnt_v 计数器*/
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)
      cnt_v <= 10'd0;
     else begin
      if(cnt_v <= V_TOTAL - 1)
         cnt_v <= 10'd0;
      else 
         cnt_v <= cnt_v + 1'd1;
     end

end
                 
endmodule