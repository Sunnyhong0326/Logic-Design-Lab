`timescale 1ns / 1ps

module Lab3_Team30_FIFO_8_t;

reg ren = 1'b0, wen = 1'b0, rst_n = 1'b1, clk = 1'b0;
reg [7:0] din = 8'd0;
wire [7:0] dout;
wire error;

always#(5)clk = !clk;

FIFO_8 m(clk, rst_n, wen, ren, din, dout, error);
initial begin
    @ (negedge clk)
	rst_n = 1'b0;
	@ (negedge clk)
	rst_n = 1'b1;
    @(negedge clk)
    din = 8'd10;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd20;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd30;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd5;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd10;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd15;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd20;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd25;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd30;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd35;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd40;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd45;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd50;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    $finish;
end



endmodule
