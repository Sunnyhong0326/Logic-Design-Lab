`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/26 00:17:49
// Design Name: 
// Module Name: Lab3_TeamX_Parameterized_Ping_Pong_Counter_t
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


module Lab3_Team30_Parameterized_Ping_Pong_Counter_t();
reg clk = 1'b1;
reg rst_n = 1'b1;
reg enable = 1'b1;
reg flip = 1'b0;
reg [3:0]max = 4'b1000;
reg [3:0]min = 4'b0000;
wire direction;
wire [3:0] out;

parameter cyc = 10;

always#(cyc/2)clk = !clk;
Parameterized_Ping_Pong_Counter Pppc(clk, rst_n, enable, flip, max, min, direction, out);


initial begin
    @(negedge clk) rst_n = 1'b0;
    @(negedge clk) 
    rst_n = 1'b1;
    max = 4'b0100;
    min = 4'b0000;
    #(cyc*5)
    @(negedge clk)flip = 1'b1;
    @(negedge clk)flip = 1'b0;
    #(cyc/2)
    #(cyc*2)
    //enable = 0
    repeat(2*4) @(posedge clk)enable = 1'b0;
    enable = 1'b1;
    #(cyc*3)
    //max < min
    max = 4'b0001;
    min = 4'b100;
    #(cyc*5)
    
    max = 4'b1111;
    min = 4'b0000;
    #(cyc*12)
    // out < min
    max = 4'b1110;
    min = 4'b1100;
    #(cyc*5)
    // out > max
    max = 4'b1000;
    min = 4'b0010;
    #(cyc*5)
    /*@(negedge clk)flip = 1'b1;
    @(negedge clk)flip = 1'b0;
    #(cyc*11/2)
    #(cyc/2*5)
    @(negedge clk)flip = 1'b1;
    @(negedge clk)flip = 1'b0;
    #(cyc)
    @(negedge clk)flip = 1'b1;
    @(negedge clk)flip = 1'b0;
    #(cyc*5/2)
    enable = 1'b0;
    #(cyc*3)
    enable = 1'b1;
    min = 4'b0000;
    max = 4'b1111;*/
	#1 $finish;
end
endmodule
