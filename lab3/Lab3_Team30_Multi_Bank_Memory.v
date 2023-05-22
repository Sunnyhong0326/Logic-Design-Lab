`timescale 1ns/1ps

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [10:0] waddr;
input [10:0] raddr;
input [7:0] din;
output [7:0] dout;

reg [3:0] bank_ren, bank_wen;
wire [7:0] bank_out[3:0]; 
always@(*)begin
       case({ren, wen})
       2'b00:begin
              bank_ren = 4'b0000;
              bank_wen = 4'b0000;
       end
       2'b01:begin
              bank_ren = 4'b0000;
              bank_wen = 4'b0000;
              bank_wen[waddr[10:9]] = 1'b1;
       end
       2'b10:begin
              bank_wen = 4'b0000;
              bank_ren = 4'b0000;
              bank_ren[raddr[10:9]] = 1'b1;
       end
       2'b11:begin
              bank_wen = 4'b0000;
              bank_ren = 4'b0000;
       end
       endcase

end

Bank b0(clk, bank_ren[0], bank_wen[0], waddr, raddr, din, bank_out[0]);
Bank b1(clk, bank_ren[1], bank_wen[1], waddr, raddr, din, bank_out[1]);
Bank b2(clk, bank_ren[2], bank_wen[2], waddr, raddr, din, bank_out[2]);
Bank b3(clk, bank_ren[3], bank_wen[3], waddr, raddr, din, bank_out[3]);

assign dout = bank_out[0] | bank_out[1] | bank_out[2] | bank_out[3];
endmodule

module Bank (clk, bank_ren, bank_wen, waddr, raddr, din, bank_out);
input clk, bank_ren, bank_wen;
input [10:0] waddr;
input [10:0] raddr;
input [7:0] din;
output [7:0] bank_out;

reg [3:0] subbank_ren, subbank_wen;
reg [6:0] addr[3:0];
wire [7:0] subbank_out[3:0];

always@(*)begin
       case({bank_ren, bank_wen})
       2'b00:begin
              subbank_ren = 4'b0000;
              subbank_wen = 4'b0000;
       end
       2'b01:begin
              subbank_ren = 4'b0000;
              subbank_wen = 4'b0000;
              subbank_wen[waddr[8:7]] = 1'b1;
              addr[waddr[8:7]] = waddr[6:0];
       end
       2'b10:begin
              subbank_wen = 4'b0000;
              subbank_ren = 4'b0000;
              subbank_ren[raddr[8:7]] = 1'b1;
              addr[raddr[8:7]] = raddr[6:0];
       end
       2'b11:begin
              subbank_wen = 4'b0000;
              subbank_ren = 4'b0000;
              subbank_ren[raddr[8:7]] = 1'b1;
              subbank_wen[waddr[8:7]] = 1'b1;
              addr[waddr[8:7]] = waddr[6:0];
              addr[raddr[8:7]] = raddr[6:0];
       end
       endcase
end

Memory m0 (clk, subbank_ren[0], subbank_wen[0], addr[0], din, subbank_out[0]);
Memory m1 (clk, subbank_ren[1], subbank_wen[1], addr[1], din, subbank_out[1]);
Memory m2 (clk, subbank_ren[2], subbank_wen[2], addr[2], din, subbank_out[2]);
Memory m3 (clk, subbank_ren[3], subbank_wen[3], addr[3], din, subbank_out[3]);

assign bank_out = subbank_out[0] | subbank_out[1] | subbank_out[2] | subbank_out[3];
endmodule

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [6:0] addr;
input [7:0] din;
output [7:0] dout;
reg [7:0]ADDRreg[127:0];
reg [7:0] dout;
reg [7:0] read;
reg [7:0] next_addr;
always@(posedge clk)begin
    if(ren == 1'b1)dout <= ADDRreg[addr];
    else if(wen == 1'b1)begin
        ADDRreg[addr] <= din;
        dout <= 8'd0;
    end
    else dout <= 8'd0;
end

endmodule
