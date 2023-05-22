`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/10 21:28:30
// Design Name: 
// Module Name: draw_1_tb
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


module draw_1_tb();
    reg clk = 1'b0;
    reg rst = 1'b0;
    reg dclk = 1'b0;
    reg enable = 1'b1;
    reg [3:0] max_idx;
    wire [1:0] diry, dirx;
    wire done;
    wire pen_down;
    wire [2:0] state;
    //wire [7:0] cur_x, cur_y;
    //wire [1:0] state;
    draw_1 d(clk, dclk, rst, enable, max_idx, dirx, diry, pen_down, done,state);
    //draw_line d(clk, rst, enable, startx, starty, endx, endy, dirx, diry, done);
    parameter cyc = 10;
    always#(cyc/2)clk = !clk;

    initial begin
        @(negedge clk)
        rst = 1'b0;
        enable = 1'b0;
        @(negedge clk)
        rst = 1'b1;
        enable = 1'b1;
        max_idx = 4'd3;
        @(negedge clk)
        rst = 1'b0;
        enable = 1'b1;
        #(20*cyc);
        @(negedge clk)
        rst = 1'b1;
        @(negedge clk)
        rst = 1'b0;
        #(78*cyc);
        $finish;
    end

endmodule
