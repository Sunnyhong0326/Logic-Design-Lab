`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 20:19:27
// Design Name: 
// Module Name: clk_div_tb
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


module clk_div_tb(

    );
    reg clk = 1'b0;
    // Outputs
    reg rst = 1'b0;
    wire clock_out;
    reg [25:0] div = 26'd30;
    // Instantiate the Unit Under Test (UUT)
    // Test the clock divider in Verilog
    clock_div uut (clk, rst, div, clock_out);
    parameter cyc = 2;
    always#(cyc/2)clk = !clk;
    initial begin
        // Initialize Inputs
        clk = 0;
        // create input clock 50MHz
        @(negedge clk)rst = 1'b1;
        @(negedge clk)rst = 1'b0;
        #(500*2);
    end
endmodule
