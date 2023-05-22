`timescale 10ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/26 20:19:52
// Design Name: 
// Module Name: Lab3_TeamX_Parameterized_Ping_Pong_Counter_fpga
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Lab3_Team30_Parameterized_Ping_Pong_Counter_fpga(clk, pb_reset, enable, pb_flip, max, min, AN, seg, dp);
input clk, pb_reset, pb_flip;
input enable;
input [3:0] max;
input [3:0] min;
output [3:0] AN;
output [0:6] seg;
output dp;

wire [3:0] out;
wire direction;
wire pb_reset_debounced;
wire pb_reset_one_pulse;
wire pb_flip_debounced;
wire pb_flip_one_pulse;
wire rst_n;
//wire flip;
wire dclk;
// one second cycle
one_second_clk one_second(clk, rst_n, dclk);
// reset push button
debounce reset_db(pb_reset_debounced, pb_reset, clk);
onepulse reset_one_pulse(pb_reset_debounced, clk, pb_reset_one_pulse);
// flip push button
debounce flip_db(pb_flip_debounced, pb_flip, clk);
onepulse flip_one_pulse(pb_flip_debounced, clk, pb_flip_one_pulse);

seven_segment_LED_display segment_display(clk, rst_n, out, direction, AN, seg);
revised_ping_pong_counter Ping_Counter(clk, dclk, rst_n, enable, pb_flip_one_pulse, max, min, direction, out);
assign dp = 1'b1;
assign rst_n = ~pb_reset_one_pulse;

endmodule

module revised_ping_pong_counter(clk, dclk, rst_n, enable, flip, max, min, direction, out);
input clk, dclk, rst_n;
input enable;
input flip;
input [3:0] max;
input [3:0] min;
output direction;
output [3:0] out;

reg [3:0] out;
reg direction;
reg [3:0]next_num;
reg next_dir;

always@(posedge clk)begin
    if(rst_n == 1'b1)begin
        if(dclk)begin
            if(enable == 1'b1 && max > min && flip == 1'b1)begin
                out <= out;
                direction <= ~direction;
            end
            else begin
                out <= next_num;
                direction <= next_dir;
            end
        end
        else begin
            if(enable == 1'b1 && max > min && flip == 1'b1)begin
                out <= out;
                direction <= ~direction;
            end
            else begin
                out <= out;
                direction <= direction;
            end
        end
    end
    else begin
        out <= min;
        direction <= 1'b1;
    end
end
always@(*)begin
    if(enable == 1'b1)begin
        if(max > min)begin
            if(out > max || out < min)next_num = out;
            else begin
                if(next_dir == 1'b1) next_num = out + 4'b0001;
                else next_num = out - 4'b0001;
            end
        end
        else next_num = out;
        end
    else next_num = out;
end
always@(*)begin
    if(enable == 1'b1)begin
        if(max > min)begin
            if(out > max || out < min) next_dir = direction;
            else begin
                if(out == min) next_dir = 1'b1;
                else if(out == max) next_dir = 1'b0;
                else next_dir = direction;
            end
        end
        else next_dir = direction;
    end
    else next_dir = direction;
end
endmodule

module debounce (pb_debounced, pb, clk);
input clk;
input pb;
output pb_debounced;
reg [3:0] DFF;
always@(posedge clk)begin
    DFF[3:1]<= DFF[2:0];
    DFF[0]<=pb;
end
assign pb_debounced = (DFF==4'b1111) ? 1'b1 : 1'b0;
endmodule

module one_second_clk(clk, rst_n, one_second_cycle);
input clk, rst_n;
output one_second_cycle;
reg [26:0] one_second_counter;
reg [26:0] next_count;
always @(posedge clk)
    begin
        if(rst_n==1'b0)
            one_second_counter <= 27'd0;
        else begin
            one_second_counter <= next_count;
        end
    end
always@(*)begin
    if(one_second_counter == 27'd99999999) next_count = 27'd0;
    else next_count = one_second_counter + 27'd1;
end
assign one_second_cycle = (one_second_counter==27'd99999999)? 1'b1:1'b0;
endmodule

module seven_segment_LED_display(clk, rst_n, out, direction, AN, seg);
input clk;
input rst_n;
input [3:0]out;
input direction;
output [3:0] AN;
output [0:6]seg;

reg [0:6] seg;
reg [3:0] AN;
reg [18:0] refresh_counter;// first 17bit creating 1ms
wire [18:0] next_refresh_count;
wire [1:0] activating_LED;

always@(posedge clk)begin
    if(rst_n == 1'b0)begin
        refresh_counter = 19'b0000000000000000000;
    end
    else begin
        refresh_counter <= next_refresh_count;
    end
end
assign next_refresh_count = refresh_counter + 19'b0000000000000000001;
assign activating_LED = refresh_counter[18:17];

always@(*)begin
    case(activating_LED)
    2'b00:begin
        AN = 4'b0111;
    end
    2'b01:begin
        AN = 4'b1011;
    end
    2'b10:begin
        AN = 4'b1101;
    end
    2'b11:begin
        AN = 4'b1110;
    end
    default:begin
        AN = 4'b1110; 
    end
    endcase
end
always@(*)begin
    if(AN == 4'b0111)begin
        if(out >= 4'b1010)seg = 7'b1001111; // 1
        else seg = 7'b0000001;// 0
    end
    else if(AN == 4'b1011)begin
        if(out == 4'b0000 || out == 4'b1010)seg = 7'b0000001;//0
        else if(out == 4'b0001 || out == 4'b1011)seg = 7'b1001111; //1
        else if(out == 4'b0010 || out == 4'b1100)seg = 7'b0010010;//2
        else if(out == 4'b0011 || out == 4'b1101)seg = 7'b0000110;//3
        else if(out == 4'b0100 || out == 4'b1110)seg = 7'b1001100;//4
        else if(out == 4'b0101 || out == 4'b1111)seg = 7'b0100100;//5
        else if(out == 4'b0110)seg = 7'b0100000;//6
        else if(out == 4'b0111)seg = 7'b0001101;//7
        else if(out == 4'b1000)seg = 7'b0000000;//8
        else seg = 7'b0000100;//9
    end
    else if (AN == 4'b1101 || AN == 4'b1110)begin
        if(direction == 1'b1)begin
            seg = 7'b0011101;//up
        end
        else if(direction == 1'b0)begin
            seg = 7'b1100011;//down
        end
        else seg = 7'b1111111;
    end
    else seg = 7'b1111111;
end

endmodule

module onepulse (PB_debounced, CLK, PB_one_pulse);
input CLK;
input PB_debounced;
output PB_one_pulse;
reg PB_one_pulse;
reg pb_delay;
always@(posedge CLK)begin
    PB_one_pulse <= PB_debounced & (!pb_delay);
    pb_delay <= PB_debounced;
end
endmodule