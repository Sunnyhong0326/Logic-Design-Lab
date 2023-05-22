`timescale 1ns / 1ps

module Lab2_Team30_Ripple_Carry_Adder_t;
reg [7:0] a, b;// input signal
reg cin;// carry in
wire cout;// carry out
wire [7:0] sum;// output wire

// instantiate the main module
Ripple_Carry_Adder m1(a, b, cin, cout, sum);

initial begin
a = 8'b00000000;
b = 8'b00000000;
cin  = 1'b0;// set all input signals to 0

// test all the input combinations, chane the signal every 1 ns
repeat(2 ** 17)begin
    #1 {a, b, cin} = {a, b, cin} + 1'b1;
end  
 
#1 $finish;// finish the test
end 
       
endmodule
