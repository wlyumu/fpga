module key_debounce(
    input clk,
    input rst_n,

    input key,
    output reg key_value,
    output reg key_flag
    
);

reg key_reg;
reg [19 : 0]key_cnt; /*延时20ms 即10的6方*/


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    key_reg <= 1'b1 ;             /*复位时将按键值恢复默认值，为高电平*/
    key_cnt <= 20'd0;             /*按键延时计数器置0*/
	 end
    else begin
        key_reg <= key;          /*保存上一次按键的状态*/
        if(key_reg != key)       /*如果key_reg != key时，即按键状态发生改变，按键按下*/
		  
           key_cnt <= 20'd1000_000;
        else begin
            if(key_cnt > 20'd0)
            key_cnt <= key_cnt - 1'b1;
            else
            key_cnt <= 20'd0;
           
        end
    end

end


always @(posedge clk or negedge rst_n) begin
     
     if(!rst_n)begin
         key_value <= 1'b1;
         key_flag  <= 1'b0;
     end

     else begin
         if(key_cnt == 1'b1)begin
             key_flag = 1'b1;
             key_value = key;
         end
         else begin
             key_flag <= 1'b0;
             key_value <= key_value;

         end
     end
    
end


endmodule // key_control_beep