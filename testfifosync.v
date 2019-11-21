module testfifosync();

parameter depth=8;
parameter width=8;

wire empty,full;
wire [clogb2(depth):0]counter_status;
wire [width-1:0]data_out;
reg clk,rst,rd_en,wr_en;
reg [width-1:0]data_in;

fifo_sync  #(depth,width)fifos(empty,full,counter_status,data_out,clk,rst,rd_en,wr_en,data_in);

reg [width-1:0]reg_data;

initial begin
clk=0;
rst=0;
rd_en=0;
wr_en=0;
data_in=0;
reg_data=0;
end

always #10 clk=~clk;

initial begin
rst=0;
#1;
rst=1;
#1;
push(1);
push(2);
push(3);
push(4);
pop(reg_data);
pop(reg_data);
pop(reg_data);
pop(reg_data);
push(5);
push(6);
push(7);
push(8);
push(1);
push(2);
push(3);
push(4);
push(44);
pop(reg_data);
pop(reg_data);
pop(reg_data);
pop(reg_data);
@(posedge clk);
@(posedge clk);
fork
push(44);
pop(reg_data);
join
fork

push(10);
pop(reg_data);
join

fork
push(20);
pop(reg_data);
join

fork
push(30);
pop(reg_data);
join
fork
push(40);
pop(reg_data);
join

@(posedge clk);
@(posedge clk);

#20;
$stop;
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

//push
task push;
input [width-1:0]in;
begin
if(full)$display("%t--full",$time);
else begin
data_in<=in;
wr_en<=1;
@(posedge clk);
#5 wr_en<=0;
end
end
endtask

//pop
task pop;
output [width-1:0]out;
begin
if(empty)$display("%t--empty",$time);
else begin
rd_en<=1;
@(posedge clk);
#5 rd_en<=0;
out=data_out;
end
end
endtask

endmodule
