module clk #(parameter DIV_N = 7'd100)
(
  input sys_clk,
  input rst_n,
  
  output reg clk_out

);

reg [9 : 0]cnt;


//时钟分频
always @(posedge sys_clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        cnt     <= 0;
        clk_out <= 0;
    end
    else begin
        if(cnt == DIV_N/2 - 1'b1) begin
            cnt     <= 10'd0;
            clk_out <= ~clk_out;
        end
        else
            cnt <= cnt + 1'b1;
    end
end


endmodule