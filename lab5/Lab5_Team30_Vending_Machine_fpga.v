`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/21 23:00:02
// Design Name: 
// Module Name: Lab5_Team30_Vending_Machine_fpga
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


module Lab5_Team30_Vending_Machine_fpga(
    input wire LEFT,
    input wire CENTER,
    input wire RIGHT,
    input wire RST,
    input wire Button,
    inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire clk,
    output wire [6:0] display,// 7 segment
	output wire [3:0] digit,// AN
    output reg [3:0] LED
    );
    // keyboard
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
    // vending machine
    reg [7:0] money, next_money;
    reg state, next_state;
    // one second
    reg [26:0] one_sec_count, next_one_sec_count;
    reg one_sec_dclk, next_one_sec_dclk;
    // push button commands
    wire Debounced_RST, Debounced_LEFT, Debounced_CENTER, Debounced_RIGHT, Debounced_BUTTON;
    wire rst, insert_five, insert_ten, insert_fifty, cancel;

    parameter [8:0] KEY_CODES [0:3] = {
        9'b0_0001_1100,// A (2'h1C) Coffee 75
        9'b0_0001_1011,// S (2'h1B) Coke 50
        9'b0_0010_0011,// D (2'h23) Oolong 30
        9'b0_0010_1011 // F (2'h2B) Water 25
    };
    parameter INSERT = 1'b0;
    parameter MAKE_CHANGE = 1'b1;

    Debounce d_rst(
        .clk(clk),
        .pb(RST),
        .debounced(Debounced_RST)
    );
    Debounce d_left(
        .clk(clk),
        .pb(LEFT),
        .debounced(Debounced_LEFT)
    );
    Debounce d_center(
        .clk(clk),
        .pb(CENTER),
        .debounced(Debounced_CENTER)
    );
    Debounce d_right(
        .clk(clk),
        .pb(RIGHT),
        .debounced(Debounced_RIGHT)
    );
    Debounce d_button(
        .clk(clk),
        .pb(Button),
        .debounced(Debounced_BUTTON)
    );
    One_Pulse o_rst(
        .clk(clk),
        .debounced(Debounced_RST),
        .one_pulse(rst)
    );
    One_Pulse o_left(
        .clk(clk),
        .debounced(Debounced_LEFT),
        .one_pulse(insert_five)
    );
    One_Pulse o_center(
        .clk(clk),
        .debounced(Debounced_CENTER),
        .one_pulse(insert_ten)
    );
    One_Pulse o_right(
        .clk(clk),
        .debounced(Debounced_RIGHT),
        .one_pulse(insert_fifty)
    );
    One_Pulse o_cancel(
        .clk(clk),
        .debounced(Debounced_BUTTON),
        .one_pulse(cancel)
    );
    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(key_valid),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
    SevenSegment seven_seg(
        .clk(clk),
        .rst(rst),
        .num(money),
        .Seven_Segment(display),
        .AN(digit)
    );
    // create one second clock divider
    always@(posedge clk)begin
        if(state != MAKE_CHANGE)begin
            one_sec_count <= 27'd0;
            one_sec_dclk <= 1'b0;
        end
        else begin
            one_sec_count <= next_one_sec_count;
            one_sec_dclk <= next_one_sec_dclk;
        end
    end

    always@(*)begin
        if(one_sec_count == 27'd99999999)begin
            next_one_sec_count  = 27'd0;
            next_one_sec_dclk = 1'b1;
        end
        else begin
            next_one_sec_count = one_sec_count + 27'd1;
            next_one_sec_dclk = 1'b0;
        end
    end
    // finite state machine
    always@(posedge clk)begin
        if(rst)begin
            money <= 8'd0;
            state <= INSERT;
        end
        else begin
            state <= next_state;
            if(state == MAKE_CHANGE)begin
                if(one_sec_dclk)money <= next_money;
                else money <= money;
            end
            else money <= next_money;
        end
    end
    always@(*)begin
        case(state)
            INSERT:begin
                if(insert_five)begin
                    if(money + 8'd5 <= 8'd100)next_money = money + 8'd5;
                    else next_money = money;
                    next_state = INSERT;
                end
                else if(insert_ten)begin
                    if(money + 8'd10 <= 8'd100)next_money = money + 8'd10;
                    else next_money = money;
                    next_state = INSERT;
                end
                else if(insert_fifty)begin
                    if(money + 8'd50 <= 8'd100)next_money = money + 8'd50;
                    else next_money = money;
                    next_state = INSERT;
                end
                else if(cancel)begin
                    next_money = money;
                    if(money == 8'd0)next_state = INSERT;
                    else next_state = MAKE_CHANGE;
                end
                else if(key_valid && key_down[last_change] == 1'b1)begin
                    if(last_change == KEY_CODES[0])begin
                        if(money >= 8'd75)begin
                            next_money = money - 8'd75;
                            next_state = MAKE_CHANGE;
                        end
                        else begin
                            next_money = money;
                            next_state = INSERT;
                        end
                    end
                    else if(last_change == KEY_CODES[1])begin
                        if(money >= 8'd50)begin
                            next_money = money - 8'd50;
                            next_state = MAKE_CHANGE;
                        end
                        else begin
                            next_money = money;
                            next_state = INSERT;
                        end
                    end
                    else if(last_change == KEY_CODES[2])begin
                        if(money >= 8'd30)begin
                            next_money = money - 8'd30;
                            next_state = MAKE_CHANGE;
                        end
                        else begin
                            next_money = money;
                            next_state = INSERT;
                        end
                    end
                    else if(last_change == KEY_CODES[3])begin
                        if(money >= 8'd25)begin
                            next_money = money - 8'd25;
                            next_state = MAKE_CHANGE;
                        end
                        else begin
                            next_money = money;
                            next_state = INSERT;
                        end
                    end
                    else begin
                        next_money = money;
                        next_state = INSERT;
                    end
                end
                else begin
                    next_money = money;
                    next_state = INSERT;
                end
            end
            MAKE_CHANGE:begin
                if(money > 0)begin
                    next_money = money - 8'd5;
                    next_state = MAKE_CHANGE;
                end
                else begin
                    next_money = 8'd0;
                    next_state = INSERT;
                end
            end
        endcase
    end
    always@(*)begin
        if(state == INSERT)begin
            if(money >= 8'd75)LED = 4'b1111;
            else if(money >= 8'd50)LED = 4'b0111;
            else if(money >= 8'd30)LED = 4'b0011;
            else if(money >= 8'd25)LED = 4'b0001;
            else LED = 4'b0000;
        end
        else LED = 4'b0000;
    end
endmodule

module SevenSegment(
    input clk, 
    input rst, 
    input [6:0] num,
    output reg [6:0] Seven_Segment, 
    output reg [3:0] AN
    );
    reg [18:0] clock_divider;
    reg [3:0] display_num;
    wire [1:0] activating_LED; 

    always@(posedge clk)begin
        if(rst)begin
            clock_divider <= 19'd0;
        end
        else begin
            clock_divider <= clock_divider + 19'd1;
        end
    end
    assign activating_LED = clock_divider[18:17];
    always@(*)begin
        case(activating_LED)
            2'b00:AN = 4'b1110;
            2'b01:AN = 4'b1101;
            2'b10:AN = 4'b1011;
            2'b11:AN = 4'b0111;
            default:AN = 4'b1111;
        endcase
    end
    always@(*)begin
        case(AN)
            4'b1110:begin
                if(num == 7'd100)display_num = 7'd0;
                else if(num >= 7'd90)display_num = num - 7'd90;
                else if(num >= 7'd80)display_num = num - 7'd80;
                else if(num >= 7'd70)display_num = num - 7'd70;
                else if(num >= 7'd60)display_num = num - 7'd60;
                else if(num >= 7'd50)display_num = num - 7'd50;
                else if(num >= 7'd40)display_num = num - 7'd40;
                else if(num >= 7'd30)display_num = num - 7'd30;
                else if(num >= 7'd20)display_num = num - 7'd20;
                else if(num >= 7'd10)display_num = num - 7'd10;
                else display_num = num;
            end
            4'b1101:begin
                if(num == 7'd100)display_num = 7'd0;
                else if(num >= 7'd90)display_num = 7'd9;
                else if(num >= 7'd80)display_num = 7'd8;
                else if(num >= 7'd70)display_num = 7'd7;
                else if(num >= 7'd60)display_num = 7'd6;
                else if(num >= 7'd50)display_num = 7'd5;
                else if(num >= 7'd40)display_num = 7'd4;
                else if(num >= 7'd30)display_num = 7'd3;
                else if(num >= 7'd20)display_num = 7'd2;
                else if(num >= 7'd10)display_num = 7'd1;
                else display_num = 7'd10;
            end
            4'b1011:begin
                if(num==7'd100)display_num = 7'd1;
                else display_num = 7'd10;
            end
            4'b0111:begin
                display_num = 7'd10;
            end
            default:begin
                display_num = 7'd10;
            end
        endcase
    end 
    
    always@(*)begin
        case(display_num)
            0 : Seven_Segment = 7'b1000000;	  //0000
            1 : Seven_Segment = 7'b1111001;   //0001                                                
            2 : Seven_Segment = 7'b0100100;   //0010                                                
            3 : Seven_Segment = 7'b0110000;   //0011                                             
            4 : Seven_Segment = 7'b0011001;   //0100                                               
            5 : Seven_Segment = 7'b0010010;   //0101                                               
            6 : Seven_Segment = 7'b0000010;   //0110
            7 : Seven_Segment = 7'b1111000;   //0111
            8 : Seven_Segment = 7'b0000000;   //1000
            9 : Seven_Segment = 7'b0010000;   //1001
            10 : Seven_Segment = 7'b1111111; // no display
            default : Seven_Segment = 7'b1111111;
        endcase
    end
endmodule

module Debounce(
    input clk,
    input pb,
    output wire debounced
);
    reg [3:0]DFF;
    always@(posedge clk)begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end
    assign debounced = (DFF == 4'b1111) ? 1'b1 : 1'b0;
endmodule

module One_Pulse(
    input clk,
    input debounced,
    output reg one_pulse
);
    reg pb_delay;
    always@(posedge clk)begin
        one_pulse <= debounced & (!pb_delay);
        pb_delay <= debounced;
    end
endmodule