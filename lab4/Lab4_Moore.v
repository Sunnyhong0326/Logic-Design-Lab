`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output [1:0] out;
output [2:0] state;
reg [1:0] out;
reg [2:0] state;
reg [2:0] next_state;
parameter S0 = 3'b000;
parameter S1 = 2'b001;
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
            if(in == 1'b0) next_state = S1;
            else next_state = S2;
        S1:
            if(in == 1'b0) next_state = S4;
            else next_state = S5;
        S2:
            if(in == 1'b0) next_state = S1;
            else next_state = S3;
        S3:
            if(in == 1'b0) next_state = S1;
            else next_state = S0;
        S4:
            if(in == 1'b0) next_state = S4;
            else next_state = S5;
        S5:
            if(in == 1'b0) next_state = S3;
            else next_state = S0;
        default:
            if(in == 1'b0) next_state = S0;
            else next_state = S1;
    endcase
end
always@(*)begin
    if(state == S0) out = 2'b11;
    else if(state == S1) out = 2'b01;
    else if(state == S2) out = 2'b11;
    else if(state == S3) out = 2'b10;
    else if(state == S4) out = 2'b10;
    else out = 2'b00;
end
endmodule
