`timescale 1ns / 1ps

module Lab3_Team30_Multi_Bank_Memory_t;
reg clk = 1'b1;
reg ren = 1'b0;
reg wen = 1'b0;
reg [10:0] waddr = 11'd0;
reg [10:0] raddr = 11'd0;
reg [7:0] din = 8'd0;
wire [7:0] dout;

//Bank b (.clk(clk), .bank_ren(ren), .bank_wen(wen), .waddr(waddr), .raddr(raddr), .din(din), .bank_out(dout));
Multi_Bank_Memory m (clk, ren, wen, waddr, raddr, din, dout);

always#(5)clk = !clk;

initial begin
    @(negedge clk)
    waddr = {4'b0000, 7'd10};
    raddr = 11'd0;
    din = 8'd1;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0001, 7'd20};
    raddr = 11'd0;
    din = 8'd2;
    ren = 1'b0;
    wen = 1'b1;   
    @(negedge clk)
    waddr = {4'b0110, 7'd30};
    raddr = 11'd0;
    din = 8'd4;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0111, 7'd40};
    raddr = 11'd0;
    din = 8'd8;
    ren = 1'b0;
    wen = 1'b1;
     @(negedge clk)
    waddr = {4'b1000, 7'd50};
    raddr = 11'd0;
    din = 8'd16;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b1001, 7'd60};
    raddr = 11'd0;
    din = 8'd32;
    ren = 1'b0;
    wen = 1'b1;   
    @(negedge clk)
    waddr = {4'b1110, 7'd70};
    raddr = 11'd0;
    din = 8'd64;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b1111, 7'd80};
    raddr = 11'd0;
    din = 8'd128;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = 11'd0;
    raddr = 11'd0;
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b0000, 7'd10};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
     @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b0001, 7'd20};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
     @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b0110, 7'd30};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b0111, 7'd40};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b1000, 7'd50};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
     @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b1001, 7'd60};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
     @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b1110, 7'd70};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b1111, 7'd80};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b1111, 7'd20};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = {4'b0011, 7'd10};
    raddr = 11'd0;
    din = 8'd20;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0111, 7'd10};
    raddr = 11'd0;
    din = 8'd25;
    ren = 1'b0;
    wen = 1'b1;   
    @(negedge clk)
    waddr = {4'b1011, 7'd10};
    raddr = 11'd0;
    din = 8'd30;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b1111, 7'd10};
    raddr = 11'd0;
    din = 8'd35;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = 11'd0;
    raddr = 11'd0;
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b0011, 7'd10};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
     @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b0111, 7'd10};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
     @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b1011, 7'd10};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b1111, 7'd10};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    
    @(negedge clk)
    waddr = 11'd0;
    raddr = 11'd0;
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    waddr = {4'b1010, 7'd78};
    raddr = 11'd0;
    din = 8'd25;
    ren = 1'b0;
    wen = 1'b1;
    @(negedge clk)
    waddr = {4'b0111, 7'd20};
    raddr = {4'b1010, 7'd78};
    din = 8'd50;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    waddr = 11'd0;
    raddr = 11'd0;
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    waddr = {4'b0111, 7'd30};
    raddr = {4'b0111, 7'd20};
    din = 8'd60;
    ren = 1'b1;
    wen = 1'b1;
    @(negedge clk)
    waddr = 11'd0;
    raddr = {4'b0111, 7'd30};
    din = 8'd0;
    ren = 1'b1;
    wen = 1'b0;
    
    @(negedge clk)
    waddr = 11'd0;
    raddr = 11'd0;
    din = 8'd0;
    ren = 1'b0;
    wen = 1'b0;
    @(negedge clk)
    $finish;
end 
   
endmodule
