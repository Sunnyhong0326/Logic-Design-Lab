`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/08 00:59:48
// Design Name: 
// Module Name: Lab4_Team30_Built_In_Self_Test_t
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


module Lab4_Team30_Built_In_Self_Test_t();
reg clk = 1'b1;
reg rst_n = 1'b1;
reg scan_en = 1'b0;
wire scan_in;
wire scan_out;
Built_In_Self_Test bin(clk, rst_n, scan_en, scan_in, scan_out);
parameter cyc = 10;
always#(cyc/2) clk=!clk;
initial begin
    @(negedge clk)
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    scan_en = 1'b1;
    #(8*cyc);
    @(negedge clk)
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    #(7*cyc);
    @(negedge clk)
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    #(7*cyc);
    $finish;
end
endmodule
