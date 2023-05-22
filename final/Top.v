`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/05 16:28:30
// Design Name: 
// Module Name: Top
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


module Top(
    input clk, 
    input rst,
    input switch,
    //input enable, 
    output [3:0] step_x, 
    output [3:0] step_y, 
    output servo,
    inout wire PS2_DATA,
	inout wire PS2_CLK,
    output reg [3:0] LED,
    output reg [4:0] DRAW_LED,
    output wire [3:0] AN,
    output wire [6:0] Seven_Segment
    );
    wire [1:0] dirx, diry;
    wire [2:0] draw_state;
    // keyboard
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
    reg draw_enable, draw_rst;
    wire pen_down;
    wire [7:0] num;
    wire [4:0] idx;
    reg [1:0] state, next_state;
    reg [2:0] count, next_count;
    reg [3:0] select, next_select;
    parameter SELECT = 2'b00;
    //parameter PREPARE = 2'b01;
    parameter RST = 2'b01;
    parameter DRAW = 2'b10;
    parameter [8:0] KEY_CODES [0:21] = {
        // left
        9'b0_0100_0101,//0
        9'b0_0001_0110,//1
        9'b0_0001_1110,//2
        9'b0_0010_0110,//3
        9'b0_0010_0101,//4
        9'b0_0010_1110,//5
        9'b0_0011_0110,//6
        9'b0_0011_1101,//7
        9'b0_0011_1110,//8
        9'b0_0100_0110,//9
        // right
        9'b0_0111_0000,//0
        9'b0_0110_1001,//1
        9'b0_0111_0010,//2
        9'b0_0111_1010,//3
        9'b0_0110_1011,//4
        9'b0_0111_0011,//5
        9'b0_0111_0100,//6
        9'b0_0110_1100,//7
        9'b0_0111_0101,//8
        9'b0_0111_1101,//9
        9'b0_0101_1010,//Enter
        9'b0_0110_0110//Back space
    };
    KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(key_valid),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
    clock_div dclk0(clk, rst, 26'd500000, dclk);
    step_motor x_axis (clk, rst, dirx, 9'd240, step_x);
    step_motor y_axis (clk, rst, diry, 9'd160, step_y);
    servo_motor write (clk, rst, pen_down, servo);
    draw drw(clk, dclk, draw_rst, draw_enable, select, dirx, diry, pen_down, done, draw_state, idx);
    //draw_line d(dclk, rst, enable_draw, 0, 0, 200, 100, dirx, diry, done);
    SevenSegment s(clk, rst, select, Seven_Segment, AN);
    always@(posedge clk)begin
        if(rst)begin
            state <= SELECT;
            select <= 4'd0;
            count <= 3'd0;
        end
        else begin
            select <= next_select;
            state <= next_state;
            count <= next_count;
        end
    end
    always@(*)begin
        case(state)
            SELECT:begin
                next_count = 3'd0;
                draw_enable = 1'b0;
                draw_rst = 1'b0;
                next_select = select;
                if(key_valid && key_down[last_change] == 1'b1)begin
                    next_state = SELECT;
                    if(last_change == KEY_CODES[0] || last_change == KEY_CODES[10])begin
                        next_select = 4'd0;
                    end
                    else if(last_change == KEY_CODES[1] || last_change == KEY_CODES[11])begin
                        next_select = 4'd1;
                    end
                    else if(last_change == KEY_CODES[2] || last_change == KEY_CODES[12])begin
                        next_select = 4'd2;
                    end
                    else if(last_change == KEY_CODES[3] || last_change == KEY_CODES[13])begin
                        next_select = 4'd3;
                    end
                    else if(last_change == KEY_CODES[4] || last_change == KEY_CODES[14])begin
                        next_select = 4'd4;
                    end
                    else if(last_change == KEY_CODES[5] || last_change == KEY_CODES[15])begin
                        next_select = 4'd5;
                    end
                    else if(last_change == KEY_CODES[6] || last_change == KEY_CODES[16])begin
                        next_select = 4'd6;
                    end
                    else if(last_change == KEY_CODES[7] || last_change == KEY_CODES[17])begin
                        next_select = 4'd7;
                    end
                    else if(last_change == KEY_CODES[8] || last_change == KEY_CODES[18])begin
                        next_select = 4'd8;
                    end
                    else if(last_change == KEY_CODES[9] || last_change == KEY_CODES[19])begin
                        next_select = 4'd9;
                    end
                    else if(last_change == KEY_CODES[20])begin
                        next_state = RST;
                    end
                end
                else begin
                    next_state = SELECT;
                end
            end
            RST:begin
                draw_enable = 1'b1;
                draw_rst = 1'b1;
                next_select = select;
                if(count <= 3'd3)begin
                    next_count = count + 3'd1;
                    next_state = RST;
                end
                else begin
                    next_count = count;
                    next_state = DRAW;
                end
            end
            DRAW:begin
                next_count = 3'd0;
                draw_enable = 1'b1;
                draw_rst = 1'b0;
                next_select = select;
                if(done)begin
                    next_state = SELECT;
                end
                else begin
                    next_state = DRAW;
                end
            end
        endcase
    end
    always@(*)begin
        LED = 4'b0000;
        if(state == SELECT)LED[0] = 1'b1;
        //else if(state == PREPARE)LED[1] = 1'b1;
        else if(state == RST) LED[1] = 1'b1;
        else LED[2] = 1'b1;
    end
    always@(*)begin
        DRAW_LED = 5'b00000;
        if(draw_state == 3'b000)DRAW_LED[0] = 1'b1;
        else if(draw_state == 3'b001)DRAW_LED[1] = 1'b1;
        else if(draw_state == 3'b010) DRAW_LED[2] = 1'b1;
        else if(draw_state == 3'b011)DRAW_LED[3] = 1'b1;
        else DRAW_LED[4] = 1'b1;;
    end
endmodule

