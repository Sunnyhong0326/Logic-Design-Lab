`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [7:0] din;
output [7:0] dout;
output error;

reg [7:0] dout, next_dout;
reg error, next_error;
reg [7:0] queue[7:0];
reg [2:0] wptr, next_wptr, rptr, next_rptr; // write pointer and read pointer
reg [3:0] count, next_count;

always@ (posedge clk)
begin
    if(rst_n == 1'b0) begin
        dout <= 8'b00000000;
        error <= 1'b0;
        wptr <= 3'b000;
        rptr <= 3'b111;
        count <= 4'b0000;
    end
    else begin
        dout <= next_dout;
        error <= next_error;
        count <= next_count;
        wptr <= next_wptr;
        rptr <= next_rptr;
    end
end        

always@(*)begin
    case({ren, wen})
        2'b00:begin
            next_dout = 8'd0;
            next_error = 1'b0;
            next_count = count;
            next_wptr = wptr;
            next_rptr = rptr;
        end
        2'b01:begin
            if(count == 4'b1000)begin
                next_error = 1'b1;
                next_count = count;
                next_wptr = wptr;
                next_rptr = rptr;
            end
            else begin
                next_error = 1'b0;
                next_count = count + 4'b0001;
                next_wptr = wptr + 3'b001;
                next_rptr = rptr;
                queue[wptr] = din;
            end
        end
        2'b10 || 2'b11:begin
            if(count == 4'b0000)begin
                next_error = 1'b1;
                next_count = count;
                next_wptr = wptr;
                next_rptr = rptr;
            end
            else begin
                next_dout = queue[rptr+3'b001];
                next_error = 1'b0;
                next_count = count + 4'b0001;
                next_wptr = wptr;
                next_rptr = rptr + 3'b001;
            end
        end
        default:begin
            next_dout = 8'd0;
            next_error = 1'b0;
            next_count = 4'b0;
            next_wptr = 3'b000;
            next_rptr = 3'b111;
        end
    endcase
end
endmodule
