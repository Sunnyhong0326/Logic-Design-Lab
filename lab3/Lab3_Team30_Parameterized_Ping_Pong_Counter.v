`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [3:0] max;
input [3:0] min;
output direction;
output [3:0] out;

reg [3:0] out;
reg direction;
reg [3:0]next_num;
reg next_dir;

always@(posedge clk)begin
    if(rst_n == 1'b1)begin
        out <= next_num;
        direction <= next_dir;
    end
    else begin
        out <= min;
        direction <= 1'b1;
    end
end

always@(*)begin
    if(enable == 1'b1)begin
        if(max > min)begin
            if(out > max || out < min)next_num = out;
            else begin
                if(next_dir == 1'b1) next_num = out + 4'b0001;
                else next_num = out - 4'b0001;
            end
        end
        else next_num = out;
        end
    else next_num = out;
end

always@(*)begin
    if(enable == 1'b1)begin
        if(max > min)begin
            if(out > max || out < min) next_dir = direction;
            else begin
                if(flip == 1'b1) next_dir <= ~direction;
                else begin
                    if(out == min) next_dir = 1'b1;
                    else if(out == max) next_dir = 1'b0;
                    else next_dir = direction;
                end
            end
        end
        else next_dir = direction;
    end
    else next_dir = direction;
end

endmodule