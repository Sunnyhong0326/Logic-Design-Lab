`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output reg dec;
reg [3:0] state;
reg [3:0] nxt_state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

always @ (posedge clk) begin
if(rst_n == 1'b0) state <= S0;
else state <= nxt_state;
end

always @ (*) begin
case (state)
S0: if (in == 1'b1) begin
        nxt_state = S1;
        dec = 1'b0;
        end
    else begin
        nxt_state = S0;
        dec = 1'b0;
        end
S1: if (in == 1'b1) begin
        nxt_state = S2;
        dec = 1'b0;
        end
    else begin
        nxt_state = S0;
        dec = 1'b0;
        end       
S2: if (in == 1'b1) begin
        nxt_state = S2;
        dec = 1'b0;
        end
    else begin
        nxt_state = S3;
        dec = 1'b0;
        end     
S3: if (in == 1'b1) begin
        nxt_state = S1;
        dec = 1'b0;
        end
    else begin
        nxt_state = S4;
        dec = 1'b0;
        end 
S4: if (in == 1'b1) begin
        nxt_state = S5;
        dec = 1'b0;
        end
    else begin
        nxt_state = S0;
        dec = 1'b0;
        end      
S5: if (in == 1'b1) begin
        nxt_state = S2;
        dec = 1'b0;
        end
    else begin
        nxt_state = S6;
        dec = 1'b0;
        end    
S6: if (in == 1'b1) begin
        nxt_state = S5;
        dec = 1'b0;
        end
    else begin
        nxt_state = S7;
        dec = 1'b0;
        end    
S7: if (in == 1'b1) begin
        nxt_state = S1;
        dec = 1'b1;
        end
    else begin
        nxt_state = S0;
        dec = 1'b0;
        end  
endcase
end 

endmodule 