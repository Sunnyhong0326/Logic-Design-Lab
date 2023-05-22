`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
input [7:0] a, b;// input
input cin;// carry in
output cout;// carry out
output [7:0] sum;// output
wire C1, C2, C3, C4, C5, C6, C7;// carry bits

// instantiate 8 full adder to construct a 8-bit ripple carry adder
Full_Adder f1(a[0], b[0], cin, C1, sum[0]);
Full_Adder f2(a[1], b[1], C1, C2, sum[1]);
Full_Adder f3(a[2], b[2], C2, C3, sum[2]);
Full_Adder f4(a[3], b[3], C3, C4, sum[3]);
Full_Adder f5(a[4], b[4], C4, C5, sum[4]);
Full_Adder f6(a[5], b[5], C5, C6, sum[5]);
Full_Adder f7(a[6], b[6], C6, C7, sum[6]);
Full_Adder f8(a[7], b[7], C7, cout, sum[7]);
    
endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;
wire w1;
wire cin_n, cout_n;

NAND_Implement n1(cin, 1'b0, 3'b110, cin_n);
NAND_Implement n2(cout, 1'b0, 3'b110, cout_n);
Majority m1(a, b, cin, cout);
Majority m2(a, b, cin_n, w1);
Majority m3(cout_n, w1, cin, sum);

endmodule

module Majority(a, b, c, out);
input a, b, c;
output out;
wire w1, w2, w3, w4;

NAND_Implement n1(a, b, 3'b001, w1);
NAND_Implement n2(a, c, 3'b001, w2);
NAND_Implement n3(b, c, 3'b001, w3);
NAND_Implement n4(w1, w2, 3'b010, w4);
NAND_Implement n5(w3, w4, 3'b010, out);

endmodule

module NAND_Implement (a, b, sel, out);
input a, b;
input [2:0] sel;
output out;
wire nsel_0, nsel_1, nsel_2;
wire [7:0] gate, s, r, o;
wire w1, w2;

NOT not0(sel[0], nsel_0);
NOT not1(sel[1], nsel_1);
NOT not2(sel[2], nsel_2);

threebitAND and0(nsel_2, nsel_1, nsel_0, s[0]);
threebitAND and1(nsel_2, nsel_1, sel[0], s[1]);
threebitAND and2(nsel_2, sel[1], nsel_0, s[2]);
threebitAND and3(nsel_2, sel[1], sel[0], s[3]);
threebitAND and4(sel[2], nsel_1, nsel_0, s[4]);
threebitAND and5(sel[2], nsel_1, sel[0], s[5]);
threebitAND and6(sel[2], sel[1], nsel_0, s[6]);
threebitAND and7(sel[2], sel[1], sel[0], s[7]);

nand m0 (gate[0], a, b); // nand gate
AND  m1 (a, b, gate[1]); // and gate
OR   m2 (a, b, gate[2]); // or gate
OR   m3 (a, b, w1);
NOT  m4 (w1, gate[3]); // nor gate
XOR m5 (a, b, gate[4]);// xor gate
XOR m6 (a, b, w2);
NOT m7 (w2, gate[5]);// xnor gate
NOT  m8 (a, gate[6]);// not gate
NOT  m9 (a, gate[7]);// not gate
AND m10 [7:0] (gate, s, r);

nand m11 [7:0] (o, r, r);
nand m12(out, o[0], o[1], o[2], o[3], o[4], o[5], o[6], o[7]);

endmodule

module threebitAND (a, b, c, out);
input a, b, c;
output out;
wire d1;

AND a1(a, b, d1);
AND a2(c, d1, out);

endmodule

module AND (a, b, out);
input a, b;
output out;
wire d1;

nand and1 (d1, a, b);
nand and2 (out, d1, d1);

endmodule

module OR(a, b, out);
input a, b;
output out;
wire o1, o2;
nand or1(o1, a, a);
nand or2(o2, b, b);
nand or3(out, o1, o2);

endmodule

module NOT (in, out);
input in;
output out;

nand not1(out, in, in);

endmodule

module XOR (a, b, out);
input a, b;
output out;
wire a_n, b_n, w1, w2;

NOT n1(a, a_n);
NOT n2(b, b_n);
AND a1(a_n, b, w1);
AND a2(a, b_n, w2);
OR  o1(w1, w2, out);

endmodule