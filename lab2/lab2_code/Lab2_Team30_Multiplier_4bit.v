`timescale 1ns/1ps

module Multiplier_4bit(a, b, p);
input [3:0] a, b;
output [7:0] p;
wire [3:0] m0, m1, m2, m3;
wire [3:0] sum0, sum1;
wire cout0, cout1;
AND a0[3:0] ({b[0], b[0], b[0], b[0]}, a, m0);
BUF b0(m0[0], p[0]);

AND a1[3:0] ({b[1], b[1], b[1], b[1]}, a, m1);
full_adder4_bits fa0({1'b0 ,m0[3:1]}, m1, 1'b0, sum0, cout0);
BUF b1(sum0[0], p[1]);

AND a2[3:0] ({b[2], b[2], b[2], b[2]}, a, m2);
full_adder4_bits fa1({cout0, sum0[3:1]}, m2, 1'b0, sum1, cout1);
BUF b2(sum1[0], p[2]);

AND a3[3:0] ({b[3], b[3], b[3], b[3]}, a, m3);
full_adder4_bits fa2({cout1, sum1[3:1]}, m3, 1'b0, p[6:3], p[7]);

endmodule

module half_adder_1bit(a, b, cin, p, g);
input a, b, cin;
output p, g;
//propagating function
XOR x0(a, b, p);
//generating function
AND a0(a, b, g);
endmodule

module full_adder4_bits(a, b, cin0, sum, cout);
input [3:0] a, b;
input cin0;
output [3:0] sum;
output cout;
wire [3:0] cin, p, g;
BUF b0(cin0, cin[0]);
half_adder_1bit ha[3:0] (a, b, cin, p, g);
calculate_sum cs[3:0] (cin, p, sum);
CLA_Gen4_bits CLA(p, g, cin[0], cin[3:1], cout);
endmodule

module calculate_sum(cin, p, sum);
input cin, p;
output sum;
XOR x0(cin, p, sum);
endmodule

module CLA_Gen4_bits(p, g, cin0, outc, cout);
input [3:0] p, g;
input cin0;
output [2:0] outc;
output cout;
wire [9:0] tmp;

AND a0(p[0], cin0, tmp[0]);
OR or0(tmp[0], g[0], outc[0]);

AND a1(p[1], g[0], tmp[1]);
AND_3bits a2(cin0, p[0], p[1], tmp[2]);
OR_3bits or1(tmp[1], tmp[2], g[1], outc[1]);

AND a3(p[2], g[1], tmp[3]);
AND_3bits a4(p[2], p[1], g[0], tmp[4]);
AND_4bits a5(cin0, p[0], p[1], p[2], tmp[5]);
OR_4bits or2(tmp[3], tmp[4], tmp[5], g[2], outc[2]);

AND a6(p[3], g[2], tmp[6]);
AND_3bits a7(p[3], p[2], g[1], tmp[7]);
AND_4bits a8(p[3], p[2], p[1], g[0], tmp[8]);
AND_5bits a9(p[3], p[2], p[1], p[0], cin0, tmp[9]);
OR_5bits or3(tmp[6], tmp[7], tmp[8], tmp[9], g[3], cout);

endmodule

module BUF(a, out);
input a;
output out;
wire tmp;
NOT n0(a, tmp);
NOT n1(tmp, out);
endmodule

module NOT(a, out);
input a;
output out;
nand not0(out, a, a);
endmodule

module XOR(a, b, out);
input a, b;
output out;
wire a_inv, b_inv, temp0, temp1;
NOT not0(a, a_inv);
NOT not1(b, b_inv);
AND and0(a, b_inv, temp0);
AND and1(a_inv, b, temp1);
OR or0(temp0, temp1, out);
endmodule

module OR(a, b, out);
input a, b;
output out;
wire temp1, temp2;
nand or0(temp1, a, a);
nand or1(temp2, b, b);
nand or2(out, temp1, temp2);
endmodule

module OR_3bits(a, b, c, out);
input a, b, c;
output out;
wire temp1;
OR or0(a, b, temp1);
OR or1(temp1, c, out);
endmodule

module OR_4bits(a, b, c, d, out);
input a, b, c, d;
output out;
wire temp1;
OR_3bits or0(a, b, c, temp1);
OR or1(temp1, d, out);
endmodule

module OR_5bits(a, b, c, d, e, out);
input a, b, c, d, e;
output out;
wire temp1;
OR_4bits or0(a, b, c, d, temp1);
OR or1(temp1, e, out);
endmodule

module AND(a, b, out);
input a, b;
output out;
wire temp0;
nand and0(temp0, a, b);
nand and1(out, temp0, temp0);
endmodule

module AND_3bits(a, b, c, out);
input a, b, c;
output out;
wire tmp;
AND a0(a, b, tmp);
AND a1(tmp, c, out);
endmodule

module AND_4bits(a, b, c, d, out);
input a, b, c, d;
output out;
wire tmp;
AND_3bits a0 (a, b, c, tmp);
AND a1 (tmp, d, out); 
endmodule

module AND_5bits(a, b, c, d, e, out);
input a, b, c, d, e;
output out;
wire tmp;
AND_4bits a0 (a, b, c, d, tmp);
AND a1(tmp, e, out);
endmodule