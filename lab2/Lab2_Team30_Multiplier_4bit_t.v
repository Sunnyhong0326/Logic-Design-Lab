`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 15:06:06
// Design Name: 
// Module Name: Lab2_Team30_Multiplier_4bit_t
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab2_Team30_Multiplier_4bit_t();
reg [3:0] a, b;
wire [7:0] p;
reg [7:0] tmp;
reg done, error;
Multiplier_4bit m0(a, b, p);
initial begin
a = 4'b0000;
b = 4'b0000;
done = 1'b0;
error = 1'b0;
tmp = 7'b0000000;
repeat(2**4)begin
    repeat(2 ** 4)begin
    tmp = a*b;
    #1 
    if (tmp!=p)
        error = 1'b1;
    else 
        error = 1'b0;
    #4
    a = a+ 4'b0001;
    end
    b = b + 4'b0001;
end
#1 error = 1'b0;
#4 done = 1'b1;
#5done = 1'b0;
$finish;
end
endmodule