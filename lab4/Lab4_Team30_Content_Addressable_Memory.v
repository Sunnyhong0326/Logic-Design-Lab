`timescale 1ns/1ps

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output [3:0] dout;
output hit;

reg [3:0] dout;
reg hit;
wire [3:0] next_dout, tmp_dout;
wire next_hit, tmp_hit;
reg [7:0]CAM[15:0];
wire [15:0] pr_encoder;

always@(posedge clk)begin
    dout <= next_dout;
    hit <= next_hit;
    if({ren,wen}==2'b01)CAM[addr] = din;
end
Comparator c0(din, CAM[0], pr_encoder[0]);
Comparator c1(din, CAM[1], pr_encoder[1]);
Comparator c2(din, CAM[2], pr_encoder[2]);
Comparator c3(din, CAM[3], pr_encoder[3]);
Comparator c4(din, CAM[4], pr_encoder[4]);
Comparator c5(din, CAM[5], pr_encoder[5]);
Comparator c6(din, CAM[6], pr_encoder[6]);
Comparator c7(din, CAM[7], pr_encoder[7]);
Comparator c8(din, CAM[8], pr_encoder[8]);
Comparator c9(din, CAM[9], pr_encoder[9]);
Comparator c10(din, CAM[10], pr_encoder[10]);
Comparator c11(din, CAM[11], pr_encoder[11]);
Comparator c12(din, CAM[12], pr_encoder[12]);
Comparator c13(din, CAM[13], pr_encoder[13]);
Comparator c14(din, CAM[14], pr_encoder[14]);
Comparator c15(din, CAM[15], pr_encoder[15]);
Priority_Encoder pe(pr_encoder, tmp_dout, tmp_hit);
assign next_dout = (ren==1'b1) ? tmp_dout : 4'b0000;
assign next_hit = (ren==1'b1) ? tmp_hit : 1'b0;

endmodule

module Comparator(a, b, out);
input [7:0] a, b;
output out;
assign out = (a == b) ? 1'b1 : 1'b0;
endmodule

module Priority_Encoder(pr_encoder, next_dout, next_hit);
input [15:0] pr_encoder;
output [3:0] next_dout;
output next_hit;
reg [3:0] next_dout;
reg next_hit;
always@(*)begin
    casex(pr_encoder)    
        16'b1xxxxxxxxxxxxxxx:begin
            next_dout = 4'b1111;
            next_hit = 1'b1;
        end
        16'b01xxxxxxxxxxxxxx:begin
            next_dout = 4'b1110;
            next_hit = 1'b1;
        end
        16'b001xxxxxxxxxxxxx:begin
            next_dout = 4'b1101;
            next_hit = 1'b1;
        end
        16'b0001xxxxxxxxxxxx:begin
            next_dout = 4'b1100;
            next_hit = 1'b1;
        end
        16'b00001xxxxxxxxxxx:begin
            next_dout = 4'b1011;
            next_hit = 1'b1;
        end
        16'b000001xxxxxxxxxx:begin
            next_dout = 4'b1010;
            next_hit = 1'b1;
        end
        16'b0000001xxxxxxxxx:begin
            next_dout = 4'b1001;
            next_hit = 1'b1;
        end
        16'b00000001xxxxxxxx:begin
            next_dout = 4'b1000;
            next_hit = 1'b1;
        end
        16'b000000001xxxxxxx:begin
            next_dout = 4'b0111;
            next_hit = 1'b1;
        end
        16'b0000000001xxxxxx:begin
            next_dout = 4'b0110;
            next_hit = 1'b1;
        end
        16'b00000000001xxxxx:begin
            next_dout = 4'b0101;
            next_hit = 1'b1;
        end
        16'b000000000001xxxx:begin
            next_dout = 4'b0100;
            next_hit = 1'b1;
        end
        16'b0000000000001xxx:begin
            next_dout = 4'b0011;
            next_hit = 1'b1;
        end
        16'b00000000000001xx:begin
            next_dout = 4'b0010;
            next_hit = 1'b1;
        end
        16'b000000000000001x:begin
            next_dout = 4'b0001;
            next_hit = 1'b1;
        end
        16'b0000000000000001:begin
            next_dout = 4'b0000;
            next_hit = 1'b1;
        end
        16'b0000000000000000:begin
            next_hit = 1'b0;
            next_dout = 4'd0;
        end
    endcase
end
endmodule