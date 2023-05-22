`timescale 1ns / 1ps

module Lab2_Team30_Decode_And_Execute_t;
reg [3:0] rs, rt;// input signal
reg [2:0] sel;// selection bits
wire [3:0] rd; // output wire

// instantiate the main module
Decode_And_Execute m1 (rs, rt, sel, rd);

initial begin
rs = 4'b0000;
rt = 4'b0000;
sel = 3'b000;// all input are 0s

// test every input combinations, change signals every 1 ns
repeat(2 ** 11)begin
    #1 {sel, rt, rs} = {sel, rt, rs} + 1'b1;
end

#1 $finish; // finish the test
end

endmodule
