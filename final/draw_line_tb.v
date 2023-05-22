`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 14:41:27
// Design Name: 
// Module Name: draw_line_tb
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


module draw_line_tb(

    );
    reg clk = 1'b0;
    reg rst = 1'b0;
    reg [7:0] startx = 8'd30;
    reg [7:0] starty = 8'd30;
    reg [7:0] endx = 8'd24;
    reg [7:0] endy = 8'd21;
    wire [1:0] dirx, diry;
    reg enable = 1'b1;
    wire done;
    //wire [7:0] cur_x, cur_y;
    //wire [1:0] state;
    draw_line d(clk, rst, enable, startx, starty, endx, endy, dirx, diry, done);
    parameter cyc = 10;
    always#(cyc/2)clk = !clk;
    initial begin
        @(negedge clk)
        rst = 1'b1;
        enable = 1'b1;
        @(negedge clk)
        rst = 1'b0;
        #(20*cyc);
        @(negedge clk)
        rst = 1'b1;
        @(negedge clk)
        rst = 1'b0;
        startx = 8'd20;
        starty = 8'd25;
        endx = 8'd83;
        endy = 8'd87;
        #(78*cyc);
        $finish;
    end
endmodule
