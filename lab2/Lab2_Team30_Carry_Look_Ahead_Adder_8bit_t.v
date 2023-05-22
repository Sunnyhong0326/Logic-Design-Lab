`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 21:46:32
// Design Name: 
// Module Name: Lab2_TeamX_Carry_Look_Ahead_Adder_8bit_t
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


module Lab2_Team30_Carry_Look_Ahead_Adder_8bit_t();
reg [7:0]a, b;
reg c0;
wire [7:0]s;
wire c8;
reg [8:0]tmp;
reg error = 1'b0, done = 1'b0;
Carry_Look_Ahead_Adder_8bit CLA(a, b, c0, s, c8);
initial begin
a = 8'b00000000;
b = 8'b00000000;
c0 = 1'b0;
tmp = 9'b000000000;
repeat(2)begin
    repeat (2 ** 8)begin
        repeat (2 ** 8)begin
            tmp = a+b+c0;
            #1 error = 1'b0; 
            if (tmp!=={c8, s})
                error = 1'b1;
            #4
            a = a + 8'b00000001;
            
        end
        b = b + 8'b00000001;
    end
    c0 = c0 + 1'b1;
end
#1 error = 1'b0;
#4 done = 1'b1;
#5done = 1'b0;
$finish; // finish the test
end
endmodule
