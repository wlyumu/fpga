module fifo_wr(

    input  clk,
    input  rst_n,
    
   
    input fifo_empty_flag,
    input fifo_full_flag,
    output reg fifo_wr_flag,
    output reg [7 : 0]fifo_wr_data
);

reg [1 : 0]wr_cnt ;


always @(posedge clk or negedge rst_n)begin

   if(!rst_n)begin
   wr_cnt <= 2'd0;
   fifo_wr_data <= 8'd0;
   end
   else begin
       case(wr_cnt)
       2'd0: begin   //fifo为空时
          if(fifo_empty_flag)begin
             fifo_wr_flag <= 1'd1;
             wr_cnt <= wr_cnt + 1'd1;
          end
          else
             wr_cnt <= wr_cnt;
        end
        2'd1: begin
            if(fifo_full_flag)begin
              fifo_wr_data <= 8'd0;
              fifo_wr_flag <= 1'd0;
              wr_cnt <= 2'd0;
           end
           else begin
            fifo_wr_flag <= 1'd1;
            fifo_wr_data <= fifo_wr_data + 1'd1;
            end
       end
       
       default:
          wr_cnt <= 2'd0;
      endcase
    
   end


end

endmodule