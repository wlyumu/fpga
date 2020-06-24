`timescale 1ns / 1ns

module tb_touch_key(
    
);

reg sys_clk;
reg sys_rst_n;
reg touch_key;

wire led_out;


initial begin
    sys_clk = 1'b0;
    sys_rst_n <= 1'b0;
    touch_key <= 1'b1;

    #20
    sys_rst_n <= 1'b1;
    #20
    touch_key <= 1'b0;
    #100
    touch_key <= 1'b1;
    #20
    touch_key <= 1'b0;
end

always #10 sys_clk = ~sys_clk;

 touch_key touch_key_inst(
    .sys_clk   (sys_clk),
    .sys_rst_n (sys_rst_n),
    .touch_key (touch_key),

    .led_out(led_out)
);


endmodule // tb_touch_key