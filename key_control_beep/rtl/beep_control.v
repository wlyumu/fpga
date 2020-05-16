module beep_control(
    input clk,
    input rst_n,

    input key_flag,
    input key_value,
    output reg beep
  
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
       beep <= 1'b0;
    
    else begin
        if(key_flag && (~key_value))
        beep <= ~beep;
        else
        beep <= beep;        
    end

end

endmodule // beep_control