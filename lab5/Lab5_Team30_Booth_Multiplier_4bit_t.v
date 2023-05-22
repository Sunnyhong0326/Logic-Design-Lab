`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/25 10:58:36
// Design Name: 
// Module Name: Lab5_Team30_Booth_Multiplier_4bit_t
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


module Lab5_Team30_Booth_Multiplier_4bit_t();
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg start = 1'b0;
    reg signed [3:0] a, b;
    wire [7:0] p;
    reg error = 1'b0;
    reg signed[7:0] tmp;

    parameter cyc = 10;
    always#(cyc/2)clk = !clk;
    
    Booth_Multiplier_4bit bm(clk, rst_n, start, a, b, p);

    initial begin
        @(negedge clk)
        error = 1'b0;
        rst_n = 1'b0;
        @(negedge clk)
        rst_n = 1'b1;
        a = 4'b0000;
        b = 4'b0000;
        repeat(2**4)begin
            repeat(2**4)begin
                tmp = a*b;
                error = 1'b0;
                start = 1'b1;
                #(cyc);
                start = 1'b0;
                #(4*cyc)
                $display("ans : %ud", p);
                if(tmp!==p)error = 1'b1;
                else error = 1'b0;
                #(2*cyc);
                a = a + 8'd1;
            end
            b = b + 8'd1;
        end
    #(cyc);
    $finish;
    end
    
endmodule
