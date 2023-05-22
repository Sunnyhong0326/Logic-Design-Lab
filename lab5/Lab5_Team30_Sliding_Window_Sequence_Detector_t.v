`timescale 1ns / 1ps

module Lab5_Team30_Sliding_Window_Sequence_Detector_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire dec;

Sliding_Window_Sequence_Detector m (clk, rst_n, in, dec);

always #5 clk = ~clk;

initial begin
@(negedge clk)
rst_n = 1'b0;
@(negedge clk)
rst_n = 1'b1;
in = 1'b0;
@(negedge clk)
in = 1'b1;
@(negedge clk)
@(negedge clk)
in = 1'b0;
@(negedge clk)
@(negedge clk)
in = 1'b1;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b1;
@(negedge clk)
@(negedge clk)
in = 1'b0;
@(negedge clk)
@(negedge clk)
in = 1'b1;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b1;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b1;
@(negedge clk)
@(negedge clk)
in = 1'b0;
@(negedge clk)
@(negedge clk)
in = 1'b1;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b1;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b1;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b0;
@(negedge clk)
in = 1'b1;
@(negedge clk)
@(negedge clk)
in = 1'b0;
@(negedge clk)
@(negedge clk)
@(negedge clk)
in = 1'b1;
@(negedge clk)
$finish;
end

endmodule
