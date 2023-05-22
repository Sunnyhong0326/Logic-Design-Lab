`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 20:23:46
// Design Name: 
// Module Name: dclk
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


module clock_div(
    input clk,
    input rst,
    input [25:0] div_num,
    output reg div_clk
    );
    reg [25:0] define_speed;
    reg [25:0] count, nxt_count;
    reg nxt_div_clk;

    always @ (posedge clk,posedge rst) begin
        if (rst == 1'b1) begin 
            count <= 26'b0;   
            div_clk <= 1'b0;            
        end
        else begin
            count <= nxt_count;
            div_clk <= nxt_div_clk;
        end
    end
    
    always @ (*) begin
        if (count == define_speed) begin
            nxt_count = 26'b0;
            nxt_div_clk = ~div_clk;
        end
        else begin
            nxt_count = count + 1'b1;
            nxt_div_clk = div_clk;
        end
    end
    always@(*)begin
        define_speed = div_num;
    end
endmodule