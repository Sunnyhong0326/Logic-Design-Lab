`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [7:0] a, b;
input c0;
output [7:0] s;
output c8;
wire [7:0] p, g ;
wire tmp;
wire [7:0] cin;    
wire [1:0] outp, outg;
NOT n0(c0, tmp);
NOT n1(tmp, cin[0]);
CLA_Gen4_bits gen0(p[3:0], g[3:0], cin[0], outp[0], outg[0], cin[3:1]);
CLA_Gen4_bits gen1(p[7:4], g[7:4], cin[4], outp[1], outg[1], cin[7:5]);
CLA_Gen2_bits gen2(outp, outg, cin[0], cin[4], c8);
half_adder_1bit ha[7:0](a, b, p, g);
calculate_sum cs[7:0](cin, p, s);
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

module calculate_sum(cin, p, sum);
input cin, p;
output sum;
XOR x0(cin, p, sum);
endmodule

module half_adder_1bit(a, b, p, g);
input a, b;
output p, g;
//propagating function
XOR x0(a, b, p);
//generating function
AND a0(a, b, g);
endmodule

module CLA_Gen4_bits(p, g, cin0, outp, outg, outc);
input [3:0] p, g;
input cin0;
output outp, outg;
output [2:0] outc;
wire [8:0] tmp;

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
OR_4bits or3(tmp[6], tmp[7], tmp[8], g[3], outg);

AND_4bits a10(p[0], p[1], p[2], p[3], outp);
endmodule

module CLA_Gen2_bits(p, g, cin0, c4, c8);
input [1:0] p, g;
input cin0;
output c4, c8;
wire [2:0] tmp;

AND a0(p[0], cin0, tmp[0]);
OR or0(tmp[0], g[0], c4);

AND a1(p[1], g[0], tmp[1]);
AND_3bits a2(cin0, p[0], p[1], tmp[2]);
OR_3bits or1(tmp[1], tmp[2], g[1], c8);
endmodule