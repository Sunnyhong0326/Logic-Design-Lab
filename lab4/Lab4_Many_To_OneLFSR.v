`timescale 1ns/1ps

module Many_To_One_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [7:0] out;
reg next_out;
always@(posedge clk)begin
    if(rst_n == 1'b0)out <= 8'b10111101;
    else begin
        out[7:1] <= out[6:0];
        out[0] <= next_out;
    end
end
always@(*)begin
    next_out= (out[1]^out[2])^(out[3]^out[7]);
end
endmodule

