`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;
reg next0;
reg next2;
reg next3;
reg next4;
always@(posedge clk)begin
    if(rst_n == 1'b0)out <= 8'b10111101;
    else begin
        out[0] <= next0;
        out[1] <= out[0];
        out[2] <= next2;
        out[3] <= next3;
        out[4] <= next4;
        out[7:5] <= out[6:4];
    end
end
always@(*)begin
    next0 = out[7];
    next2 = out[7]^out[1];
    next3 = out[7]^out[2];
    next4 = out[7]^out[3];
end
endmodule