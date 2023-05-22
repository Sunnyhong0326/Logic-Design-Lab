`timescale 1ns/1ps

module Round_Robin_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [3:0] wen;
input [7:0] a, b, c, d;
output [7:0] dout;
output valid;

reg [1:0] fiforead;
wire [1:0] next_fiforead;
reg [1:0] round_robin;
reg [3:0] ren;
wire [7:0] Output [3:0];
reg valid;
wire [3:0] error;

always@(posedge clk)begin
    if(rst_n == 1'b0)begin
        fiforead <= 2'b00;
    end
    else begin
        fiforead <= next_fiforead;
        round_robin <= fiforead;
    end
end
always@(*)begin
    if(wen[round_robin] == 1'b1) valid = 1'b0;
    else if(error[round_robin] == 1'b1) valid = 1'b0;
    else valid = 1'b1;
end
always @ (*)
begin
    if(wen[fiforead] == 1'b1)
        ren = 4'b0000;
    else
        case(fiforead)
        2'b00: ren = 4'b0001;
        2'b01: ren = 4'b0010;
        2'b10: ren = 4'b0100;
        2'b11: ren = 4'b1000;
        endcase
end
assign next_fiforead = fiforead + 2'b01;
assign dout =  valid ? Output[round_robin] : 8'd0;
FIFO_8 fa(clk, rst_n, wen[0], ren[0], a, Output[0], error[0]);
FIFO_8 fb(clk, rst_n, wen[1], ren[1], b, Output[1], error[1]);
FIFO_8 fc(clk, rst_n, wen[2], ren[2], c, Output[2], error[2]);
FIFO_8 fd(clk, rst_n, wen[3], ren[3], d, Output[3], error[3]);
           
endmodule

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
