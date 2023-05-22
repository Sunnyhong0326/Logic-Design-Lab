`timescale 1ns / 1ps

module Lab4_Team30_1A2B_fpga(sw, clk, reset, start, enter, AN, seg, LED, dp);
input [3:0] sw;
input reset, start, enter, clk;
output [3:0] AN;
output [0:6] seg;
output [15:0] LED;
output dp;
reg [1:0] state, nxt_state;
reg [15:0] in, nxt_in, tmp_in;
reg [1:0] counter, nxt_counter;
reg [3:0] A, B, nxt_A, nxt_B;
wire [15:0] answer;
wire rst_debounced, str_debounced, ent_debounced;
wire rst_n;
parameter S0 = 2'b00 , S1 = 2'b01, S2 = 2'b10;

assign dp = 1'b1;
assign rst_n = ~rst_one_pulse;
assign LED = answer;

debounce d1 (reset, clk, rst_debounced);
debounce d2 (start, clk, str_debounced);
debounce d3 (enter, clk, ent_debounced);
one_pulse o1 (rst_debounced, clk, rst_one_pulse);
one_pulse o2 (str_debounced, clk, str_one_pulse);
one_pulse o3 (ent_debounced, clk, ent_one_pulse);
random_LFSR r1 (clk, rst_n, str_one_pulse, LED);
seven_segment s1 (clk, rst_n, in, state, AN, seg);

always @ (posedge clk) begin
if (rst_n == 1'b0) begin
    state <= S0;
    counter <= 2'd0;
    A <= 4'd0;
    B <= 4'd0;
    end
else begin 
    state <= nxt_state;
    counter <= nxt_counter;
    in <= nxt_in;
    A <= nxt_A;
    B <= nxt_B;
    end
end

always @ (*) begin
case(state)
S0: begin
    nxt_in = {4'h1, 4'ha, 4'h2, 4'hb};
    if(str_one_pulse) begin
        nxt_state = S1;
        nxt_counter = 2'd0;
        end
    else nxt_state = S0;
    end
S1: begin
    case(counter)
    2'b00: begin
        nxt_in = {12'd0, sw};
        if(ent_one_pulse) begin
            nxt_counter = counter + 2'b01;
            nxt_state = S1;
            tmp_in[15:12] = sw;
            if(sw == LED[15:12]) begin
                nxt_A = A + 4'd1;
                nxt_B = B;
                end
            else if(sw == LED[11:8]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[7:4]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[3:0]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else begin
                nxt_A = A;
                nxt_B = B;
                end
            end
        else begin
            nxt_counter = counter;
            nxt_state = S1;
            end
        end
    2'b01: begin
        nxt_in = {8'd0, tmp_in[15:12], sw};
        if(ent_one_pulse) begin
            nxt_counter = counter + 2'b01;
            nxt_state = S1;
            tmp_in[11:8] = sw;
            if(sw == LED[11:8]) begin
                nxt_A = A + 4'd1;
                nxt_B = B;
                end
            else if(sw == LED[15:12]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[7:4]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[3:0]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else begin
                nxt_A = A;
                nxt_B = B;
                end
            end
        else begin
            nxt_counter = counter;
            nxt_state = S1;
            end
        end
    2'b10: begin
        nxt_in = {4'd0, tmp_in[15:8], sw};
        if(ent_one_pulse) begin
            nxt_counter = counter + 2'b01;
            nxt_state = S1;
            tmp_in[7:4] = sw;
            if(sw == LED[7:4]) begin
                nxt_A = A + 4'd1;
                nxt_B = B;
                end
            else if(sw == LED[15:12]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[11:8]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[3:0]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else begin
                nxt_A = A;
                nxt_B = B;
                end
            end
        else begin
            nxt_counter = counter;
            nxt_state = S1;
            end
        end
    default: begin
        nxt_in = {tmp_in[15:4], sw};
        if(ent_one_pulse) begin
            nxt_counter = counter + 2'b01;
            nxt_state = S2;
            tmp_in[3:0] = sw;
            if(sw == LED[3:0]) begin
                nxt_A = A + 4'd1;
                nxt_B = B;
                end
            else if(sw == LED[15:12]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[11:8]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else if(sw == LED[7:4]) begin
                nxt_A = A;
                nxt_B = B + 4'd1;
                end
            else begin
                nxt_A = A;
                nxt_B = B;
                end
        end
         else begin
            nxt_counter = counter;
            nxt_state = S1;
            end
        end           
     endcase   
     end
S2: begin
    nxt_in = {A, 4'ha, B, 4'hb};
    if(ent_one_pulse) begin
        tmp_in = 16'd0;
        nxt_A = 4'd0;
        nxt_B = 4'd0;
        if(A == 4'd4) nxt_state = S0;
        else nxt_state = S1;
        end
    else nxt_state = S2;
    end
endcase   
end  
    
endmodule

module debounce (pb, clk, out);
input pb, clk;
output out;
reg [3:0] DFF;

always @ (posedge clk) begin

  DFF[0] <= pb;
  DFF[3:1] <= DFF[2:0];
 end

assign out = ((DFF == 4'b1111) ? 1'b1 : 1'b0);

endmodule

module one_pulse (pb_debounced, clk, pb_one_pulse);
input pb_debounced, clk;
output reg pb_one_pulse;
reg pb_n;

always@(posedge clk) begin
pb_n <= ~pb_debounced;
pb_one_pulse <= (pb_debounced & pb_n);
end

endmodule

module one_second (clk, rst_n, second);
input clk, rst_n;
output reg second;
reg [26:0] counter, nxt_counter;
reg nxt_second;

always @ (posedge clk) begin
if(rst_n == 1'b0) begin
    counter <= 27'd0;
    second <= 1'b0;
    end
else begin
    counter <= nxt_counter;
    second <= nxt_second;
    end
end

always @ (*) begin
if(counter == 27'd49999999) begin
    nxt_second = ~second;
    nxt_counter = 27'd0;
    end
else begin
    nxt_second = second;
    nxt_counter = counter + 27'd1;
    end
end

endmodule

module seven_segment (clk, rst_n, in, state, AN, seg);
input clk, rst_n;
input [15:0] in;
input [1:0] state;
output reg [3:0] AN;
output reg [0:6] seg; 
reg [18:0] refresh_clock;
wire second;
wire [1:0] activate_AN;
parameter S0 = 2'b00 , S1 = 2'b01, S2 = 2'b10;

assign activate_AN = refresh_clock[18:17];

one_second o1 (clk, rst_n, second);

always @ (*) begin
case(state)
S0, S2: begin
case(activate_AN)
2'b00 : AN = 4'b1110;
2'b01 : AN = 4'b1101;
2'b10 : AN = 4'b1011;
2'b11 : AN = 4'b0111;
endcase
end
S1: begin
case(activate_AN)
2'b00 : begin
    if(second) AN = 4'b1110;
    else AN = 4'b1111;
    end
2'b01 : AN = 4'b1101;
2'b10 : AN = 4'b1011;
2'b11 : AN = 4'b0111;
endcase
end
endcase
end

always @ (posedge clk)begin
if(rst_n == 1'b0) refresh_clock <= 19'd0;
else refresh_clock <= refresh_clock + 19'd1;
end

always @ (*) begin
if(AN == 4'b0111) begin
    if(in[15:12] == 4'd0) seg = 7'b0000001;
    else if(in[15:12] == 4'd1) seg = 7'b1001111;
    else if(in[15:12] == 4'd2) seg = 7'b0010010;
    else if(in[15:12] == 4'd3) seg = 7'b0000110;
    else if(in[15:12] == 4'd4) seg = 7'b1001100;
    else if(in[15:12] == 4'd5) seg = 7'b0100100;
    else if(in[15:12] == 4'd6) seg = 7'b0100000;
    else if(in[15:12] == 4'd7) seg = 7'b0001101;
    else if(in[15:12] == 4'd8) seg = 7'b0000000;
    else if(in[15:12] == 4'd9) seg = 7'b0000100;
    else if(in[15:12] == 4'd10) seg = 7'b0001000;
    else if(in[15:12] == 4'd11) seg = 7'b1100000;
    else seg = 7'b0000001;
    end
else if(AN == 4'b1011) begin
    if(in[11:8] == 4'd0) seg = 7'b0000001;
    else if(in[11:8] == 4'd1) seg = 7'b1001111;
    else if(in[11:8] == 4'd2) seg = 7'b0010010;
    else if(in[11:8] == 4'd3) seg = 7'b0000110;
    else if(in[11:8] == 4'd4) seg = 7'b1001100;
    else if(in[11:8] == 4'd5) seg = 7'b0100100;
    else if(in[11:8] == 4'd6) seg = 7'b0100000;
    else if(in[11:8] == 4'd7) seg = 7'b0001101;
    else if(in[11:8] == 4'd8) seg = 7'b0000000;
    else if(in[11:8] == 4'd9) seg = 7'b0000100;
    else if(in[11:8] == 4'd10) seg = 7'b0001000;
    else if(in[11:8] == 4'd11) seg = 7'b1100000;
    else seg = 7'b0000001;
    end
else if(AN == 4'b1101) begin
    if(in[7:4] == 4'd0) seg = 7'b0000001;
    else if(in[7:4] == 4'd1) seg = 7'b1001111;
    else if(in[7:4] == 4'd2) seg = 7'b0010010;
    else if(in[7:4] == 4'd3) seg = 7'b0000110;
    else if(in[7:4] == 4'd4) seg = 7'b1001100;
    else if(in[7:4] == 4'd5) seg = 7'b0100100;
    else if(in[7:4] == 4'd6) seg = 7'b0100000;
    else if(in[7:4] == 4'd7) seg = 7'b0001101;
    else if(in[7:4] == 4'd8) seg = 7'b0000000;
    else if(in[7:4] == 4'd9) seg = 7'b0000100;
    else if(in[7:4] == 4'd10) seg = 7'b0001000;
    else if(in[7:4] == 4'd11) seg = 7'b1100000;
    else seg = 7'b0000001;
    end
else if(AN == 4'b1110) begin
    if(in[3:0] == 4'd0) seg = 7'b0000001;
    else if(in[3:0] == 4'd1) seg = 7'b1001111;
    else if(in[3:0] == 4'd2) seg = 7'b0010010;
    else if(in[3:0] == 4'd3) seg = 7'b0000110;
    else if(in[3:0] == 4'd4) seg = 7'b1001100;
    else if(in[3:0] == 4'd5) seg = 7'b0100100;
    else if(in[3:0] == 4'd6) seg = 7'b0100000;
    else if(in[3:0] == 4'd7) seg = 7'b0001101;
    else if(in[3:0] == 4'd8) seg = 7'b0000000;
    else if(in[3:0] == 4'd9) seg = 7'b0000100;
    else if(in[3:0] == 4'd10) seg = 7'b0001000;
    else if(in[3:0] == 4'd11) seg = 7'b1100000;
    else seg = 7'b0000001;
    end
else seg = 7'b1111111;
end

endmodule

module random_LFSR(clk, rst_n, start, random);
input clk;
input rst_n;
input start;
output reg [15:0] random;
reg [3:0] out0, out1, out2, out3;
reg [3:0] DFF;
reg [1:0] counter;
wire w1;
assign w1 = (DFF[0] ^ DFF[3]);

always @ (posedge clk) begin
if (rst_n == 1'b0) begin
    DFF <= 4'b1000;
    counter <= 2'd0;
    out0 <=  4'd0;
    out1 <=  4'd0;
    out2 <=  4'd0;
    out3 <=  4'd0;
    end
else begin
    DFF[0] <= DFF[3];
    DFF[1] <= w1;
    DFF[2] <= DFF[1];
    DFF[3] <= DFF[2];
    if(start) begin
        random[15:12] <= out3;
        random[11:8] <= out2;
        random[7:4] <= out1;
        random[3:0] <= out0;
        end
    else random <= random;
    end
end

always @ (*) begin
case(counter)
2'b00 : if(DFF <= 4'd9) begin
            if(DFF != out1)begin
                if(DFF != out2) begin
                    if(DFF != out3) begin
                    out0 = DFF;
                    counter = counter + 1'b1;
                    end
                    else out0 = out0;
                end
                else out0 = out0;
            end
            else out0 = out0;
        end
        else out0 = out0;
2'b01 : if(DFF <= 4'd9) begin
            if (DFF != out0) begin
                if(DFF != out2) begin
                    if(DFF != out3) begin
                    out1 = DFF;
                    counter = counter + 1'b1;
                    end
                    else out1 = out1;
                end
                else out1 = out1;
            end
            else out1 = out1;
        end
        else out1 = out1;
2'b10 : if(DFF <= 4'd9) begin
            if (DFF != out0) begin
                if (DFF != out1) begin
                    if(DFF != out3) begin
                    out2 = DFF;
                    counter = counter + 1'b1;
                    end
                    else out2 = out2;
                end
                else out2 = out2;
            end
            else out2 = out2;
        end
        else out2 = out2;
default : if(DFF <= 4'd9) begin
            if (DFF != out0) begin
                if (DFF != out1) begin
                    if(DFF != out2) begin
                    out3 = DFF;
                    counter = counter + 1'b1;
                    end
                    else out3 = out3;
                end
                else out3 = out3;
            end
            else out3 = out3;
        end
        else out3 = out3;
endcase
end

endmodule
