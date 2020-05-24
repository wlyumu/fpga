`timescale  1ns / 1ns

module ipcore;

parameter SYSPERIOD = 20 ;

reg clk;
reg rst_n;


wire clk1;
wire clk2;
wire clk3;
wire clk4;


always #(SYSPERIOD / 2) begin
    clk <= ~clk;
    
end


initial begin
    clk <= 1'b0;
    rst_n <= 1'b0;

    #(20 * SYSPERIOD)
    rst_n <= 1'b1;
end

ip_pll   u_ip_pll(

.clk   (clk),
.rst_n (rst_n),
.clk1  (clk1),
.clk2  (clk2),
.clk3  (clk3),
.clk4  (clk4)
);


endmodule   