`timescale 1ns / 1ps

module decode_and_execute_fpga(rs, rt, sel, AN, seg, dp);
input [3:0] rs, rt;
input [2:0] sel;
output [3:0] AN;
output [0:6] seg;
output dp;
wire [3:0] rd, rd_n;
wire [15:0] w;

Decode_And_Execute d1(rs, rt, sel, rd);

NOT n1 [3:0] (rd, rd_n);
BUF b1(1'b0, AN[0]);
BUF b2(1'b1, AN[1]);
BUF b3(1'b1, AN[2]);
BUF b4(1'b1, AN[3]);
BUF b5(1'b1, dp);
and a1(w[0], rd_n[3], rd_n[2], rd_n[1], rd_n[0]);//0000
and a2(w[1], rd_n[3], rd_n[2], rd_n[1], rd[0]);//0001
and a3(w[2], rd_n[3], rd_n[2], rd[1], rd_n[0]);//0010
and a4(w[3], rd_n[3], rd_n[2], rd[1], rd[0]);//0011
and a5(w[4], rd_n[3], rd[2], rd_n[1], rd_n[0]);//0100
and a6(w[5], rd_n[3], rd[2], rd_n[1], rd[0]);//0101
and a7(w[6], rd_n[3], rd[2], rd[1], rd_n[0]);//0110
and a8(w[7], rd_n[3], rd[2], rd[1], rd[0]);//0111
and a9(w[8], rd[3], rd_n[2], rd_n[1], rd_n[0]);//1000
and a10(w[9], rd[3], rd_n[2], rd_n[1], rd[0]);//1001
and a11(w[10], rd[3], rd_n[2], rd[1], rd_n[0]);//1010
and a12(w[11], rd[3], rd_n[2], rd[1], rd[0]);//1011
and a13(w[12], rd[3], rd[2], rd_n[1], rd_n[0]);//1100
and a14(w[13], rd[3], rd[2], rd_n[1], rd[0]);//1101
and a15(w[14], rd[3], rd[2], rd[1], rd_n[0]);//1110
and a16(w[15], rd[3], rd[2], rd[1], rd[0]);//1111
nor o1(seg[0], w[0], w[2], w[3], w[5], w[6], w[7], w[8], w[9], w[10], w[12], w[14], w[15]);
nor o2(seg[1], w[0], w[1], w[2], w[3], w[4], w[7], w[8], w[9], w[10], w[13]);
nor o3(seg[2], w[0], w[1], w[3], w[4], w[5], w[6], w[7], w[8], w[9], w[10], w[11], w[13]);
nor o4(seg[3], w[0], w[2], w[3], w[5], w[6], w[8], w[9], w[11], w[12], w[13], w[14]);
nor o5(seg[4], w[0], w[2], w[6], w[8], w[10], w[11], w[12], w[13], w[14], w[15]);
nor o6(seg[5], w[0], w[4], w[5], w[6], w[8], w[9], w[10], w[11], w[12], w[14], w[15]);
nor o7(seg[6], w[2], w[3], w[4], w[5], w[6], w[8], w[9], w[10], w[11], w[13], w[14], w[15]);

endmodule

