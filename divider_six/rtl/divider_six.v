module divider_six
#(parameter DEIVIDE_NUM = 6)
(
   input sys_clk,
   input sys_rst_n,
   
   output reg clk_flag

);

reg [4:0] cnt;
//
//always @(posedge sys_clk or negedge sys_rst_n)begin
//   if(!sys_rst_n)
//     cnt <= 5'd0;
//   else if(cnt == DEIVIDE_NUM / 2 -1)
//     cnt <= 5'd0;
//   else 
//     cnt <= cnt + 1'd1;
//
//end
//
//
//always @(posedge sys_clk or negedge sys_rst_n)begin
//   if(!sys_rst_n)
//      clk_out <= 1'b0;
//   else if(cnt == DEIVIDE_NUM / 2 - 1)
//      clk_out <= ~clk_out;
//   else  
//      clk_out <= clk_out;
//end


always @(posedge sys_clk or negedge sys_rst_n)begin
   if(!sys_rst_n)
     cnt <= 5'd0;
   else if(cnt == DEIVIDE_NUM  -1)
     cnt <= 5'd0;
   else 
     cnt <= cnt + 1'd1;

end


always @(posedge sys_clk or negedge sys_rst_n)begin
   if(!sys_rst_n)
      clk_flag <= 1'b0;
   else if(cnt == DEIVIDE_NUM - 2)
      clk_flag <= 1'b1;
   else  
      clk_flag <= 1'b0;
end


endmodule



