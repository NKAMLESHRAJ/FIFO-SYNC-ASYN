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
if(!rst)begin
counter_status<=1'b0;
end
else begin
if((!empty&&rd_en)&&(!full&&wr_en))begin
counter_status<=counter_status;
end
else if(!empty&&rd_en) begin
counter_status<=counter_status-1;
end
else if(!full&&wr_en) begin
counter_status<=counter_status+1;
end
end
end
//read pointer
always @(posedge clk,negedge rst)
begin
if(!rst)
rd_ptr<=0;
else if(!empty&&rd_en)begin
//rd_ptr<=counter_status; 
rd_ptr<=rd_ptr+1;end
//else
//rd_ptr<=counter_status;
end

//write pointer
always @(posedge clk,negedge rst)begin
if(!rst)begin
wr_ptr<=0;end
else begin
if(!full&&wr_en) begin
wr_ptr<=wr_ptr+1;end
//else
//wr_ptr<=counter_status;
end
end

//read data from fifo
always @(posedge clk,negedge rst)begin
if(!rst)begin
data_out<=0;end
else begin
if(!empty&&rd_en) begin
data_out<=fifo[rd_ptr];
end
end
end

//write data in fifo
always @(posedge clk,negedge rst)
begin
/*if(!rst)begin
data_out<=0;end
else begin*/
if(!full&&wr_en) begin
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
