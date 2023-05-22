`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output done;
output [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

reg done;
reg [1:0] state, next_state;
reg [1:0] count, next_count;
reg [15:0] in_a, in_b, next_in_a, next_in_b, ans, gcd;

always@(posedge clk)begin
    if(rst_n==1'b0)begin
        state <= WAIT;
        count <= 2'b00;
    end
    else begin
        state <= next_state;
        count <= next_count;
        in_a <= next_in_a;
        in_b <= next_in_b;
    end
end

always@(*)begin
    case(state)
        WAIT:begin
            gcd = 16'd0;
            done = 1'b0;
            next_count = 2'b00;
            if(start==1'b0)begin
                next_state = WAIT;
            end
            else begin
                next_state = CAL;
                next_in_a = a;
                next_in_b = b;
            end
        end
        CAL:begin
            gcd = 16'd0;
            done = 1'b0;
            next_count = 2'b00;
            if(in_a == 16'd0)begin
                next_state = FINISH;
                ans = in_b;
            end
            else if (in_b == 16'd0)begin
                next_state = FINISH;    
                ans = in_a;
            end
            else begin
                next_state = CAL;
                if(in_a > in_b)begin
                    next_in_a = in_a - in_b;
                end
                else begin
                    next_in_b = in_b - in_a;
                end
            end
        end
        FINISH:begin
            gcd = ans;
            done = 1'b1;
            if(count == 2'b01)begin
                next_state = WAIT;
                next_count = 2'b00;
            end
            else begin
                next_state = FINISH;
                next_count = count + 2'b01;
            end
        end
    endcase
end
endmodule
