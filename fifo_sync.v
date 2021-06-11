module fifo_sync #(parameter depth=8,width=8)
(
output empty,full,
output reg[clogb2(depth):0]counter_status,[width-1:0]data_out,
input clk,rst,rd_en,wr_en,[width-1:0]data_in
);

reg [width-1:0]fifo[depth-1:0];
reg [clogb2(depth)-1:0]rd_ptr,wr_ptr;

assign full=(counter_status==depth);
assign empty=(counter_status==0);

//status_counter
always @(posedge clk,negedge rst)begin
if(!rst)
counter_status<=8'b0;
else begin
if((!empty&&rd_en)&&(!full&&wr_en))
counter_status<=counter_status;
else begin
if(!empty&&rd_en)
counter_status<=counter_status-1;
if(!full&&wr_en) 
counter_status<=counter_status+1;
end
end
  
//read pointer//write pointer
always @(posedge clk,negedge rst)
begin
if(!rst)begin
rd_ptr<=0;
wr_ptr<=0;end
else begin
if(!empty&&rd_en)begin
rd_ptr<=rd_ptr+1;end
if(!full&&wr_en) begin
wr_ptr<=wr_ptr+1;end
end
end

//read data from fifo//write data in fifo
always @(posedge clk,negedge rst)begin
if(!rst)
data_out<=0;
else begin
if(!empty&&rd_en)
data_out<=fifo[rd_ptr];
if(!full&&wr_en) 
fifo[wr_ptr]<=data_in;
end
end

//clogb2
function integer clogb2;
input [31:0] depth1;
begin
depth1=depth1 - 1;
for(clogb2=0;depth1>0;clogb2=clogb2+1)
depth1 = depth1 >> 1;
end
endfunction

endmodule
