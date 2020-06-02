
module lcd_disp(
   input clk,
	input rst_n,
	
	input      [10 : 0] pixel_xpos,
	input      [10 : 0] pixel_ypos,
	output reg [15 : 0] pixel_data

);

parameter H_DISP = 11'd480;
parameter V_DISP = 11'd272;

localparam WHITE  = 16'b11111_111111_11111;     //RGB565 白色
localparam BLACK  = 16'b00000_000000_00000;     //RGB565 黑色
localparam RED    = 16'b11111_000000_00000;     //RGB565 红色
localparam GREEN  = 16'b00000_111111_00000;     //RGB565 绿色
localparam BLUE   = 16'b00000_000000_11111;     //RGB565 蓝色
    



always @(posedge clk or negedge rst_n)begin

   if(!rst_n)begin
	pixel_data <= 15'd0;
   end
	else begin
	   if( (pixel_ypos > 0) && (pixel_ypos < (V_DISP / 5 ))) 
		   pixel_data <= WHITE;
		else  if((pixel_ypos > 0) && (pixel_ypos < (V_DISP * 2/ 5 ))) 
		   pixel_data <= RED; 
	   else  if((pixel_ypos > 0) && (pixel_ypos < (V_DISP * 3/ 5 )))
		   pixel_data <= BLACK;
		else  if((pixel_ypos > 0) &&  (pixel_ypos < (V_DISP * 4/ 5 ))) 
		   pixel_data <= GREEN;
		else 
		   pixel_data <= BLUE;
	end

end
endmodule