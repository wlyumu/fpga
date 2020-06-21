

`timescale 1 ns/ 1 ns
module tb_divider_six(
  
);

  reg sys_clk;
  reg sys_rst_n;

  wire clk_flag;

initial   begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;

    #50 
    sys_rst_n <= 1'b1;
end

always #10 sys_clk = ~sys_clk;


//测试模块实例化
divider_six
#(
   . DEIVIDE_NUM (6)
)
divider_six_ins(
 . sys_clk    (sys_clk),
 . sys_rst_n  (sys_rst_n),

 . clk_flag    (clk_flag)

);


endmodule // 