module flag(clk,carry,in,out);
// flag register give 2 bit output  carry,zero;
input[31:0] in;
output reg[1:0] out;
input carry,clk;

always@(posedge clk)
begin
if(in==32'h00000000)
begin
out=2'b10;
end
else
begin
out=2'b00;
end

out[1]=carry;

end
endmodule

module ALU(en,clk,op1,op2,mode,dataout,carry,flagout);
input clk,en;
input[31:0] op1,op2;
input [3:0] mode;
output reg [31:0] dataout;
output reg carry;
output wire [1:0]flagout;

flag fl(clk,carry,dataout,flagout);
always@(posedge clk)
if(en==1'b1)
begin
  //addition
  if(mode==4'b0001)
  begin
  {carry,dataout} = {1'b0,op1} + {1'b0,op2};
  end
  //subtraction
  else if(mode==4'b0010)
  begin
 {carry,dataout} = {1'b0,op1} - {1'b0,op2};
  end
  //and
  else if(mode==4'b0011)
  begin
  dataout=op1&op2; 
  end
  //or
  else if(mode==4'b0100)
  begin
  dataout=op1|op2; 
  end
  //complement
  else if(mode==4'b0101)
  begin
  dataout=~op1; 
  end
  //rightshift
  else if(mode==4'b0110)
  begin
  dataout={op1[0],op1[31:1]};
  end
  //leftshift
  else if(mode==4'b0111)
  begin
  dataout={op1[30:0],op1[31]};
  end
  


end




endmodule


module testALU;
reg en,clk;
wire carry;
wire [31:0] dataout;
reg [31:0] op1,op2;
reg[3:0] mode;
wire [1:0] flagout;

ALU st(en,clk,op1,op2,mode,dataout,carry,flagout);

initial
begin
$dumpfile("regalu.vcd");
$dumpvars(0,testALU);
$monitor("%d %d %d %d %d %d",$time,op1,op2,dataout,carry,flagout);
clk=1;
en=1;

//addition
op1=32'hFFFFFFFF;
op2=1;
mode=4'b0001;

#5

//subtraction
op1=05;
op2=01;
mode=4'b0010;

#5

//AND
op1=5;
op2=1;
mode=4'b0011; 

#5

//OR
op1=2;
op2=1;
mode=4'b0100; 

#5

//COMPLEMENT
op1=32'h00000000;
mode=4'b0101;

#5
//RIGHT SHIFT
op1=32'h00000001;
mode=4'b0110;

//LEFT SHIFT
#5
op1=32'h7FFFFFFF;
mode=4'b0111;
#5




$finish;
end
always
begin
#2 clk=~clk;
end

endmodule
//iverilog -o alu.vvp ALU32_PROJ.v
