`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
input clk;
input rst_n; 
input start;
input signed [3:0] a, b;
output signed [7:0] p;

parameter [1:0] WAIT = 2'b00;
parameter [1:0] CAL = 2'b01;
parameter [1:0] FINISH = 2'b10;

reg [1:0] state, next_state;
reg [1:0] count, next_count;
reg signed [9:0] A, S, P, next_P;
reg signed [7:0] p;

always@(posedge clk)begin
    if(!rst_n)begin
        state <= WAIT;
        count <= 2'b00;
    end
    else begin
        state <= next_state;
        count <= next_count;
        P <= next_P;
    end
end
always@(*)begin
    case(state)
        WAIT:begin
            p = 8'd0;
            next_count = 2'b00;
            if(start)begin
                next_state = CAL;
                A = 10'd0;
                A[9:5] = a;
                S = 10'd0;
                S[9:5] = -a;
                next_P = 10'd0;
                next_P[4:1] = b;
            end
            else next_state = WAIT;
        end
        CAL:begin
            p = 8'd0;
            case(P[1:0])
                2'b00: next_P = P >>> 1;
                2'b01:begin
                    next_P = (P + A)>>>1;
                end
                2'b10:begin
                    next_P = (P + S)>>>1;
                end
                2'b11:next_P = P >>> 1;
            endcase 
            if(count == 2'b11)begin
                next_count = 2'b00;
                next_state = FINISH;
            end
            else begin
                next_count = count + 2'b01;
                next_state = CAL;
            end
        end
        FINISH:begin
            p = P[8:1];
            next_count = 2'b00;
            next_state = WAIT;
        end
    endcase
end

endmodule
