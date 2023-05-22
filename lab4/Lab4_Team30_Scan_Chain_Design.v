`timescale 1ns/1ps

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;

reg [7:0] SDFF;
wire [7:0] mul;
always@(posedge clk)begin
    if(rst_n==1'b0)begin
        SDFF <= 8'b00000000;
    end
    else begin
        if(scan_en)begin
            SDFF[7]<=scan_in;
            SDFF[6:0]<=SDFF[7:1];
        end
        else begin
            SDFF[7:0] <= mul[7:0];
        end
    end
end
assign mul = SDFF[7:4]*SDFF[3:0];
assign scan_out = SDFF[0];
endmodule

