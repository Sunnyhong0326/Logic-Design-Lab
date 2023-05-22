`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 12:15:30
// Design Name: 
// Module Name: Lab4_Team30_Content_Addressable_Memory_t
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


module Lab4_Team30_Content_Addressable_Memory_t();
reg clk = 1'b1;
reg wen = 1'b0;
reg ren = 1'b0;
reg [7:0] din;
reg [3:0]addr;
wire[3:0] dout;
wire hit;
Content_Addressable_Memory cam(clk, wen, ren, din, addr, dout, hit);
parameter cyc = 10;
always#(cyc/2)clk = !clk;
initial begin
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd15;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd14;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd13;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd12;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd11;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd10;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd9;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd8;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd7;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd6;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd5;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd4;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd3;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd2;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd1;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd0;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b0;
    addr = 4'd0;
    din = 8'd0;
    #(3*cyc)
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b1;
    addr = 4'd0;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b1;
    addr = 4'd0;
    din = 8'd8;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b1;
    addr = 4'd0;
    din = 8'd35;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd4;
    din = 8'd87;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd9;
    din = 8'd87;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd3;
    din = 8'd52;
    @(negedge clk)
    wen = 1'b1;
    ren = 1'b0;
    addr = 4'd10;
    din = 8'd34;
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    addr = 4'd0;
    din = 8'd87;
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    addr = 4'd0;
    din = 8'd52;
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    addr = 4'd0;
    din = 8'd34;
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b1;
    addr = 4'd0;
    din = 8'd4;
    @(negedge clk)
    wen = 1'b0;
    ren = 1'b0;
    addr = 4'd0;
    din = 8'd0;
    #(2*cyc)
$finish;
end
endmodule
