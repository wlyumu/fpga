module i2c_driver #(
  parameter SLAVE_ADDR = 7'b101_0000,
  parameter CLK_FREQ   = 26'd50_000_000,
  parameter I2C_FREQ   = 18'd250_000
)
(
   input               clk,
   input               rst_n,
   input               i2c_exec,   // I2C触发执行信号
   input               bit_ctrl,   //字地址位控制
   input               i2c_rh_wl,  //i2c读写控制信号
   input      [15 : 0] i2c_addr,   //I2C器件内地址
   input      [ 7 : 0] i2c_data_w, //I2C要写的数据
   
   output reg [ 7 : 0] i2c_data_r, //I2C要读的数据
   output reg          i2c_done  , //I2C一次操作完成
   output reg          scl       , //I2C的SCL时钟信号
   inout               sda       , //I2C的SDA信号

   output reg          i2c_driv_clk // I2C的驱动时钟
)
reg          sda_dir;     //I2C数据(SDA)方向
reg          sda_out;     // sda输出信号
reg  [9 : 0] clk_cnt;     //分频时钟计数器


wire         sda_in    ;  //sda输出信号
wire [8 : 0] clk_divier;  //分频时钟系数

//当sda_dir = 1时， sda为写入数据， 当sda_dir = 0时，sda为高组态，
assign sda        = sda_dir ? sda_out : 1'bz
assign clk_divier = (CLK_FREQ / I2C_FREQ) >> 2'd3; 
//产生I2C的SCL的四倍频率的驱动时钟， 1MHZ
always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
    clk_cnt <= 10'd0;
   else begin
    if(clk_cnt == clk_divier - 1)begin
      i2c_driv_clk <= ~ i2c_driv_clk;
      clk_cnt      <= 10'd0;
      end
    else 
       clk_cnt <= clk_cnt + 1'd1;
   
   end

end