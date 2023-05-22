`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 23:40:59
// Design Name: 
// Module Name: Lab4_Team30_Scan_Chain_Design_t
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


module Lab4_Team30_Scan_Chain_Design_t();
reg clk = 1'b1;
reg rst_n = 1'b1;
reg scan_in = 1'b0;
reg scan_en = 1'b0;
wire scan_out;

Scan_Chain_Design scd(clk, rst_n, scan_in, scan_en, scan_out);

parameter cyc = 10;
always#(cyc/2) clk = !clk;

initial begin
    @(negedge clk)
    rst_n = 1'b0;
    @(negedge clk)
    rst_n = 1'b1;
    scan_en = 1'b1;
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b0;
    scan_en = 1'b0;
    @(negedge clk)
    scan_en = 1'b1;
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b0;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b1;
    @(negedge clk)
    scan_in = 1'b0;
    #(9*cyc);
    $finish;
end
endmodule
