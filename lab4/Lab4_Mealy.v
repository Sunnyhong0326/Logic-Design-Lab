`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output out;
output [2:0] state;
reg out;
reg [2:0] state;
reg [2:0] next_state;
parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
always@(posedge clk)begin
    if(rst_n == 1'b0) state <= S0;
    else state <= next_state;
end
always@(*)begin
    case(state)
        S0:
            if(in == 1'b0)begin
                next_state = S0;
                out = 1'b0;
            end
            else begin
                next_state = S2;
                out = 1'b1;
            end
        S1:
            if(in == 1'b0)begin
                next_state = S0;
                out = 1'b1;
            end
            else begin
                next_state = S4;
                out = 1'b1;
            end
        S2:
            if(in == 1'b0)begin
                next_state = S5;
                out = 1'b1;
            end
            else begin
                next_state = S1;
                out = 1'b0;
            end
        S3:
            if(in == 1'b0)begin
                next_state = S3;
                out = 1'b1;
            end
            else begin
                next_state = S2;
                out = 1'b0;
            end
        S4:
            if(in == 1'b0)begin
                next_state = S2;
                out = 1'b1;
            end
            else begin
                next_state = S4;
                out = 1'b1;
            end
        S5:
            if(in == 1'b0)begin
                next_state = S3;
                out = 1'b0;
            end
            else begin
                next_state = S4;
                out = 1'b0;
            end
        default:
            if(in == 1'b0)begin
                next_state = S0;
                out = 1'b0;
            end
            else begin
                next_state = S2;
                out = 1'b1;
            end
    endcase
end
endmodule
