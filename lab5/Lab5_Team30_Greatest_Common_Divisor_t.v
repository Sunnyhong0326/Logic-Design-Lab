`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/21 16:30:33
// Design Name: 
// Module Name: Lab5_Team30_Greatest_Common_Divisor_t
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


module Lab5_Team30_Greatest_Common_Divisor_t();
reg clk = 1'b1, rst_n = 1'b1;
reg start = 1'b0;
reg [15:0] a;
reg [15:0] b;
wire done;
wire [15:0] gcd;

Greatest_Common_Divisor gcd0(clk, rst_n, start, a, b, done, gcd);

parameter cyc = 10;
always#(cyc/2)clk = !clk;

initial begin
    @(negedge clk)
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    a = 16'd56;
    b = 16'd14;
    @(negedge clk)
    start = 1'b1;
    a = 16'd7;
    b = 16'd49;
    #(3)
    a = 16'd32;
    b = 16'd48;
    @(negedge clk)
    start = 1'b0;
    #(8*cyc);
    @(negedge clk)
    start = 1'b1;
    a = 16'd90;
    b = 16'd45;
    @(negedge clk)
    start = 1'b0;
    #(6*cyc)
    @(negedge clk)
    start = 1'b1;
    a = 16'd49;
    b = 16'd57;
    @(negedge clk)
    start = 1'b0;
    #(20*cyc);   
$finish;
end
endmodule
