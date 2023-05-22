`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/25 21:52:16
// Design Name: 
// Module Name: Lab3_Team30_Parameterized_Ping_Pong_Counter_t
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


module Lab3_Team30_Ping_Pong_Counter_t();
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b1;
wire direction;
wire [3:0] out;

parameter cyc = 10;

always#(cyc/2)clk = !clk;
Ping_Pong_Counter Ppc(clk, rst_n, enable, direction, out);


initial begin
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) rst_n = 1'b1;
    #(cyc/2)
    #(cyc*45)
    #(cyc*5)
    @(negedge clk) enable = 1'b0;
    #(cyc*5)
    @(negedge clk) enable = 1'b1;
    #(cyc/2)
    #(cyc*3)
    @(posedge clk) enable = 1'b0;
    #(cyc*5)
    @(posedge clk) enable = 1'b1;
    #(cyc*6)
	#1 $finish;
end
endmodule
