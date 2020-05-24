module fifo_rd(

    input  clk,
    input  rst_n,
    
   
    input fifo_empty_flag,
    input fifo_full_flag,
    output reg fifo_rd_flag,
    input [7 : 0]fifo_rd_data
);

reg [1 : 0]rd_cnt ;
reg [7 : 0]data;


always @(posedge clk or negedge rst_n)begin

   if(!rst_n)begin
   rd_cnt <= 2'd0;
   data <= 8'd0;
   end
   else begin
       case(rd_cnt)
       2'd0: begin   //fifo为满时
          if(fifo_full_flag)begin
             fifo_rd_flag <= 1'd1;
             rd_cnt <= rd_cnt + 1'd1;
          end
          else
             rd_cnt <= rd_cnt;
        end
        2'd1: begin
            if(fifo_empty_flag)begin
              data <= 8'd0;
              fifo_rd_flag <= 1'd0;
              rd_cnt <= 2'd0;
           end
           else begin
            fifo_rd_flag <= 1'd1;
            data <= fifo_rd_data;
            end
       end
       
       default:
          rd_cnt <= 2'd0;
      endcase
    
   end


end

endmodule