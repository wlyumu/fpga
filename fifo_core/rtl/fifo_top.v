module fifo_core(

  input clk,
  input rst_n
);


wire fifo_wr_empty_flag;
wire fifo_wr_full_flag;
wire fifo_wr_flag;
wire [7 : 0] fifo_wr_data;
wire            wrusedw ;        

wire fifo_rd_empty_flag;
wire fifo_rd_full_flag;
wire fifo_rd_flag;
wire [7 : 0] fifo_rd_data;
wire            rdusedw ;         

 fifo_wr   u_fifo_wr(

    .clk   (clk),
    .rst_n (rst_n),
    
   
    .fifo_empty_flag (fifo_wr_empty_flag),
    .fifo_full_flag  (fifo_wr_full_flag),
    .fifo_wr_flag    (fifo_wr_flag), 
    .fifo_wr_data    (fifo_wr_data)
);


fifo_rd(

   .clk     (clk),
   .rst_n   (rst_n),
  
   .fifo_empty_flag (fifo_rd_empty_flag),
   .fifo_full_flag  (fifo_rd_full_flag),
   .fifo_rd_flag    (fifo_rd_flag),
   .fifo_rd_data    (fifo_rd_data)
);


fifo	fifo_inst (
	.data ( fifo_wr_data ),
	.rdclk ( clk ),
	.rdreq ( fifo_rd_flag ),
	.wrclk ( clk ),
	.wrreq ( fifo_wr_flag ),
	.q ( fifo_rd_data ),
	.rdempty ( fifo_rd_empty_flag ),
	.rdfull ( fifo_rd_full_flag ),
	.rdusedw ( rdusedw ),
	.wrempty ( fifo_wr_empty_flag ),
	.wrfull ( fifo_wr_full_flag ),
	.wrusedw ( wrusedw )
	);
endmodule

