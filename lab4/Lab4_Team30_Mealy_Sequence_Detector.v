`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/07 19:39:17
// Design Name: 
// Module Name: Mealy_Sequence_Detector
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


module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;
parameter S0 = 4'b0000;
parameter S1 = 4'b0001;
parameter S2 = 4'b0010;
parameter S3 = 4'b0011;
parameter S4 = 4'b0100;
parameter S5 = 4'b0101;
parameter S6 = 4'b0110;
parameter S7 = 4'b0111;
parameter S8 = 4'b1000;
parameter S9 = 4'b1001;
reg [3:0] state, next_state;
reg dec;
always@(posedge clk)begin
    if(!rst_n)begin
        state <= S0;
    end
    else begin
        state <= next_state;
    end
end
always@(*)begin
    case(state)
        S0:begin
            if(in)begin
                next_state = S1;
                dec = 1'b0;
            end
            else begin
                next_state = S6;
                dec = 1'b0;
            end
        end
        S1:begin
            if(in)begin
                next_state = S4;
                dec = 1'b0;
            end
            else begin
                next_state = S2;
                dec = 1'b0;
            end
        end
        S2:begin
            if(in)begin
                next_state = S9;
                dec = 1'b0;
            end
            else begin
                next_state = S3;
                dec = 1'b0;
            end
        end
        S3:begin
            if(in)begin
                next_state = S0;
                dec = 1'b1;
            end
            else begin
                next_state = S0;
                dec = 1'b0;
            end
        end
        S4:begin
            if(in)begin
                next_state = S5;
                dec = 1'b0;
            end
            else begin
                next_state = S9;
                dec = 1'b0;
            end
        end
        S5:begin
            if(in)begin
                next_state = S0;
                dec = 1'b0;
            end
            else begin
                next_state = S0;
                dec = 1'b1;
            end
        end
        S6:begin
            if(in)begin
                next_state = S7;
                dec = 1'b0;
            end
            else begin
                next_state = S8;
                dec = 1'b0;
            end
        end
        S7:begin
            if(in)begin
                next_state = S3;
                dec = 1'b0;
            end
            else begin
                next_state = S9;
                dec = 1'b0;
            end
        end
        S8:begin
            if(in)begin
                next_state = S9;
                dec = 1'b0;
            end
            else begin
                next_state = S9;
                dec = 1'b0;
            end
        end
        S9:begin
            if(in)begin
                next_state = S0;
                dec = 1'b0;
            end
            else begin
                next_state = S0;
                dec = 1'b0;
            end
        end
        default:begin
            next_state = S0;
            dec = 1'b0;
        end
    endcase
end
endmodule
