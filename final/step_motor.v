`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 01:52:54
// Design Name: 
// Module Name: step_motor
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


module step_motor(
    input clk,
    input rst,
    input [1:0] direction,
    input [9:0] pixel,
    output reg [3:0] signal
    );
    

    reg [11:0] position, nxt_position;
    wire div_clk;
    

    clock_div clock_Div(
        .clk(clk),
        .rst(rst),
        .div_num(25'd100000),
        .div_clk(div_clk)
        );
    
    always @ (posedge div_clk, posedge rst)
    begin
        if (rst == 1'b1) begin
            position <= 12'd0;
            end
        else begin
            position <= nxt_position;
            end
    end

    always @ (*) begin
        case(direction)
        2'b00: begin
            nxt_position = position;
            signal = 4'd0;
            end
        2'b01 : begin
            if(position < (pixel * 5)) begin
                nxt_position = position + 1'b1;
                case(position[1:0])
                2'b00 : signal = 4'b1100;
                2'b01 : signal = 4'b0110;
                2'b10 : signal = 4'b0011;
                2'b11 : signal = 4'b1001;
                endcase
                end     
            else begin
                nxt_position = position;
                signal = 4'd0;
                end
            end      
        2'b10, 2'b11 : begin
            if(position >= 9'd0) begin
                nxt_position = position - 1'b1;
                case(position[1:0])
                2'b00 : signal = 4'b1100;
                2'b01 : signal = 4'b0110;
                2'b10 : signal = 4'b0011;
                2'b11 : signal = 4'b1001;
                endcase
                end     
            else begin
                nxt_position = position;
                signal = 4'd0;
                end
            end      
        endcase
    end
endmodule
