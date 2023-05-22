`timescale 1ns / 1ps

module Lab5_Team30_Traffic_Light_Controller_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg lr_has_car = 1'b0;
wire [2:0] hw_light, lr_light;

Traffic_Light_Controller m (clk, rst_n, lr_has_car, hw_light, lr_light);
always #5 clk = ~clk;

initial begin
@(negedge clk)
rst_n = 1'b0;
@(negedge clk)
rst_n = 1'b1;
#800
@(negedge clk)
lr_has_car = 1'b1;
#500
@(negedge clk)
lr_has_car = 1'b0;
#1800
@(negedge clk)
lr_has_car = 1'b1;
#500
@(negedge clk)
lr_has_car = 1'b0;
#1000
@(negedge clk)
lr_has_car = 1'b1;
#1000
@(negedge clk)
lr_has_car = 1'b0;
#1000
$finish;
end

endmodule
