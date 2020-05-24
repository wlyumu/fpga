module ip_pll(

    input clk,
    input rst_n,
    
    output  clk1,
    output  clk2,
    output  clk3,
    output  clk4

);

wire locked;

wire pll_rst_P = rst_n & locked;

ip_core u_ip_core(
	.areset  (~ rst_n),
	.inclk0  (clk),
	.c0      (clk1),  
	.c1      (clk2), 
	.c2      (clk3),
	.c3      (clk4),
	.locked  (locked)
    );
    
endmodule




