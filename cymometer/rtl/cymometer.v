module cymometer #(CLK_FS = 26'd50_000_000)
(
  input clk_fs,
  input rst_n,
  
  input clk_fx,
  
  output reg [19 : 0] data_fx;

);

localparam GATE_CLK_CNT = 16'd5_000;

/*待测时钟*/
reg gata_fx_d0;
reg gata_fx_d1;
reg [31 : 0]gata_fx_cnt;
reg [31 : 0]gata_fx_cnt_temp;
/*基准时钟*/
reg gata_fs;   /*基准时钟下的门控信号*/
reg gata_fs_r;

reg gata_fs_d0;
reg gata_fs_d1;

reg [31 : 0]gata_fs_cnt;

reg [31 : 0]gata_fs_cnt_temp;

/*门控计数*/
reg [15 : 0]gata_cnt;
/*门控信号*/
reg gata;

wire  gata_fx_nege;
wire  gata_fs_nege;

assign gata_fx_nege = gata_fx_d1 &(~ gata_fx_d0);
assign gata_fs_nege = gata_fs_d0 &(~ gata_fs_d1);                   
/*门控计数器*/
always @(posedge clk_fx or negedge rst_n)begin
   if(!rst_n)
     gata_cnt <= 16'd0;
    else begin
     if(gata_cnt <= GATE_CLK_CNT + 16'd20)
       gata_cnt <= gata_cnt + 1'd1;   
     else 
       gata_cnt <= 16'd0;
    end
end


/*产生门控信号*/
always @(posedge clk_fs or negedge rst_n)begin
   if(!rst_n)
      gata <= 1'b0;
    else begin
       if( gata_cnt < 16'd10)
          gata <= 1'b0;
        else if(gata_cnt < GATE_CLK_CNT + 4'd10)
          gata <= 1'b1;
        else if(gata_cnt < GATE_CLK_CNT + 5'd20)
          gata <= 1'b0;
    end
end


/*将门控信号同步到基准时钟*/
always @(posedge clk_fs or negedge rst_n)begin
  if(!rst_n)begin
     gata_fs   <= 1'b0;
     gata_fs_r <= 1'b1;
  end
  else begin
     gata_fs <= gata;
     gata_fs_r <= gata_fs;
  end
end

/*捕获基准时钟下门控信号的下降沿*/
always @(posedge clk_fs or negedge rst_n)begin
  if(!rst_n)begin
     gata_fs_d0 <= 1'd0;
     gata_fs_d1 <= 1'd0;
  end
  else begin
     gata_fs_d0 <= gata_fs;
     gata_fs_d1 <= gata_fs_d0;
  end

end

/*捕获被测时钟下门控信号的下降沿*/
always @(posedge clk_fx or negedge rst_n)begin
   if(!rst_n)begin
     gata_fx_d0 = 1'b0;
     gata_fx_d1 = 1'b0;
   end
   else begin
     gata_fx_d0 <= gata;
     gata_fx_d1 <= gata_fx_d0;
   end
end

/*对被测信号下门控信号为高电平时计数*/
always @(posedge clk_fx or negedge rst_n)begin
   if(!rst_n)
      gata_fx_cnt <= 32'd0;
    else begin
      if(gata)
        gata_fx_cnt_temp <= gata_fx_cnt_temp + 1'b1;
       else if(gata_fx_nege)begin
        gata_fx_cnt <= gata_fx_cnt_temp;
        gata_fx_cnt_temp <= 32'd0;
        end
    end
end


/*对被测信号下门控信号为高电平时计数*/
always @(posedge clk_fs or negedge rst_n)begin
   if(!rst_n)
      gata_fs_cnt <= 32'd0;
    else begin
      if(gata_fs)
        gata_fs_cnt_temp <= gata_fs_cnt_temp + 1'b1;
       else if(gata_fs_nege)begin
        gata_fs_cnt <= gata_fs_cnt_temp;
        gata_fs_cnt_temp <= 32'd0;
        end
    end
end

/*计算频率*/
always @(posedge clk_fs or negedge rst_n)begin
   if(!rst_n)
      data_fx <= 20'd0;
    else begin
       data_fx = CLK_FS / gata_fs_cnt * gata_fx_cnt;
    end
end
endmodule