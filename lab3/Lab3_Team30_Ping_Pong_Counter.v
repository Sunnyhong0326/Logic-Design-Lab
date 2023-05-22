`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output direction;
output [3:0] out;

reg [3:0] out;
reg direction;
reg [3:0] next_num;
reg next_dir;

always @(posedge clk)
begin
    if(rst_n == 1'b1)begin
        out <= next_num;
        direction <= next_dir;
    end
    else begin
        out <= 4'b0000;
        direction <= 1'b1;
    end
end
always@(*)begin
    if(enable == 1'b1)begin
        if(out == 4'b0000 ) next_dir = 1'b1;
        else if(out == 4'b1111) next_dir = 1'b0;
        else next_dir = direction;
    end
    else next_dir = direction;
end

always@(*)begin
    if(enable == 1'b1)begin
        if(direction == 1'b1)begin
            if(out == 4'b1111)next_num = 4'b1110;
            else next_num = out + 4'b0001;
        end
        else begin
            if(out == 4'b0000)next_num = 4'b0001;
            else next_num = out - 4'b0001;
        end
    end
    else next_num = out;
end

endmodule