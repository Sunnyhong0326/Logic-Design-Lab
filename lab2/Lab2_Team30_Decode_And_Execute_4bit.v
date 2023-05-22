`timescale 1ns/1ps

module Decode_And_Execute(rs, rt, sel, rd);
input [3:0] rs, rt; // input signal
input [2:0] sel; // selection signal
output [3:0] rd; // output signal
wire [3:0] w1, w2, w3, w4, w5, w6, w7, w8;
wire cout1, cout2;// the carry out of ADD and SUB, which I don't need

// all the instructions
ADD m1 (rs, rt, 1'b0, w1, cout1);// cin = 1'b0
SUB m2 (rs, rt, w2, cout2);
BITWISE_AND m3 (rs, rt, w3);
BITWISE_OR m4 (rs, rt, w4);
RS_CIR_LEFT_SHIFT m5 (rs, w5);
RT_ARI_RIGHT_SHIFT m6 (rt, w6);
COMPARE_EQ m7 (rs, rt, w7);
COMPARE_GT m8 (rs, rt, w8);

// input results into 8x1 MUX to select output
four_bit_8x1_mux m9(w1, w2, w3, w4, w5, w6, w7, w8, sel, rd);

endmodule

module half_adder(a, b, s, c);
input a, b;
output s, c;
XOR x1(a, b, s);
AND a1(a, b, c);

endmodule

module full_adder(a, b, cin, s, c);
input a, b, cin;
output s, c;
wire w1, w2, w3;
// instantiate two half adders to construct a full adder
half_adder h1(a, b, w1, w2);
half_adder h2(w1, cin, s, w3);
OR o1(w3, w2, c);

endmodule

module ADD (a, b, c0, out, cout);
input [3:0] a, b;
input c0;
output [3:0] out;
output cout;
wire c1, c2, c3, c4;
// instantiate 4 full adders to construct a 4-bit ripple carry adder
full_adder f1(a[0], b[0], c0, out[0], c1);
full_adder f2(a[1], b[1], c1, out[1], c2);
full_adder f3(a[2], b[2], c2, out[2], c3);
full_adder f4(a[3], b[3], c3, out[3], cout);

endmodule

module SUB (a, b, out, cout);
input [3:0] a, b;
output [3:0] out;
output cout;
wire [3:0] b_n;
NOT n1 [3:0] (b, b_n); // get 1's complement of b
ADD a1(a, b_n, 1'b1, out, cout);// instantiate an ADD module
                                // cin = 1

endmodule

module BITWISE_AND(a, b, out);
input [3:0] a, b;
output [3:0] out;
AND a1[3:0] (a, b, out);// 4-bit AND

endmodule

module BITWISE_OR(a, b, out);
input [3:0] a, b;
output [3:0] out;
OR o1[3:0] (a, b, out);// 4-bit OR

endmodule

module RS_CIR_LEFT_SHIFT(in, out);
input [3:0] in;
output[3:0] out;
// use 4 buffer to connect input and output
BUF b1(in[3], out[0]);
BUF b2(in[0], out[1]);
BUF b3(in[1], out[2]);
BUF b4(in[2], out[3]);

endmodule

module RT_ARI_RIGHT_SHIFT(in, out);
input [3:0] in;
output[3:0] out;
// use 4 buffer to connect input and output
BUF b1(in[1], out[0]);
BUF b2(in[2], out[1]);
BUF b3(in[3], out[2]);
BUF b4(in[3], out[3]);

endmodule

module COMPARE_EQ(a, b, out);
input [3:0] a, b;
output [3:0] out;
wire gt;
// use 3 buffer to assign 1'b1 to out[1], out[2], out[3]
BUF b1(1'b1, out[1]);
BUF b2(1'b1, out[2]);
BUF b3(1'b1, out[3]);
// instantiate a COMPARE module
// connect eq with out[0]
COMPARE c1(a, b, gt, out[0]);

endmodule

module COMPARE_GT(a, b, out);
input [3:0] a, b;
output [3:0] out;
wire eq;
// use 3 buffer to assign 1'b1 to out[1], out[3]
// and assign 1'b0 to out[2]
BUF b1(1'b1, out[1]);
BUF b2(1'b0, out[2]);
BUF b3(1'b1, out[3]);
// instantiate a COMPARE module
// connect gt with out[0]
COMPARE c1(a, b, out[0], eq);

endmodule


module COMPARE(a, b, gt, eq);
input [3:0] a, b;
output gt, eq;
wire [3:0] o;
wire w1, w2, w3, w4, w5;
SUB s1(a, b, o, w1); // instantiate a SUB module

// w4 = 1 when o = 4'b0000
OR o1(o[3], o[2], w2);
OR o2(o[1], w2, w3);
OR o3(o[0], w3, w4);
NOT n1(w4, w5);

AND a1(w1, w4, gt);
AND a2(w1, w5, eq);

endmodule

// NOT gate
module NOT(in, out);
input in;
output out;
Universal_Gate u1(1'b1, in, out);

endmodule

// AND gate
module AND(a, b, out);
input a, b;
output out;
wire b_n;
NOT n1(b, b_n);
Universal_Gate u1(a, b_n, out);

endmodule

// OR gate
module OR(a, b, out);
input a, b;
output out;
wire w1, a_n, b_n;
NOT n1(a, a_n);
NOT n2(b, b_n);
AND a1(a_n, b_n, w1);
NOT n3(w1, out);

endmodule

// XOR gate
module XOR(a, b, out);
input a, b;
output out;
wire a_n, b_n, and_1, and_2;
NOT n1(a, a_n);
NOT n2(b, b_n);
AND and1(a, b_n, and_1);
AND and2(a_n, b, and_2);
OR o1(and_1, and_2, out);

endmodule

// buffer
module BUF(in, out);
input in;
output out;
wire w1;
NOT n1(in, w1);
NOT n2(w1, out);

endmodule

// XNOR gate
module XNOR(a, b, out);
input a, b;
output out;
XOR x1(a, b, w1);
NOT n1(w1, out);

endmodule

// NOR gate
module NOR(a, b, out);
input a, b;
output out;
OR o1(a, b, w1);
NOT n1(w1, out);

endmodule

// 4-bit 8x1 MUX
module four_bit_8x1_mux(a, b, c, d, e, f, g, h, sel, out);
input [3:0] a, b, c, d, e, f, g, h;
input [2:0] sel;
output [3:0] out;
wire [2:0] sel_n;
wire [3:0] w1, w2, w3, w4, w5, w6, w7, w8;
NOT n1 [2:0] (sel, sel_n);// ~sel = sel_n

// connect selection bits and inputs with 4-bit AND gates
four_bit_and a1 [3:0] (a, sel_n[2], sel_n[1], sel_n[0], w1);
four_bit_and a2 [3:0] (b, sel_n[2], sel_n[1], sel[0], w2);
four_bit_and a3 [3:0] (c, sel_n[2], sel[1], sel_n[0], w3);
four_bit_and a4 [3:0] (d, sel_n[2], sel[1], sel[0], w4);
four_bit_and a5 [3:0] (e, sel[2], sel_n[1], sel_n[0], w5);
four_bit_and a6 [3:0] (f, sel[2], sel_n[1], sel[0], w6);
four_bit_and a7 [3:0] (g, sel[2], sel[1], sel_n[0], w7);
four_bit_and a8 [3:0] (h, sel[2], sel[1], sel[0], w8);

// connect results and outputs with a 8-bit OR gate
eight_bit_or e1 [3:0] (w1, w2, w3, w4, w5, w6, w7, w8, out);

endmodule

// 4-bit AND gate
module four_bit_and (a, b, c, d, out);
input a, b, c, d;
output out;
wire w1, w2;
AND a1(a, b, w1);
AND a2(w1, c, w2);
AND a3(w2, d, out);

endmodule

// 8-bit OR gate
module eight_bit_or(a, b, c, d, e, f, g, h, out);
input a, b, c, d, e, f, g, h;
output out;
wire w1, w2, w3, w4, w5, w6;
OR o1(a, b, w1);
OR o2(w1, c, w2);
OR o3(w2, d, w3);
OR o4(w3, e, w4);
OR o5(w4, f, w5);
OR o6(w5, g, w6);
OR o7(w6, h, out);

endmodule