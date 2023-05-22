`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 10:51:05
// Design Name: 
// Module Name: draw_1
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

module draw(
        input clk,
        input dclk,
        input rst,
        input enable,
        input [3:0] select,
        output [1:0] dirx,
        output [1:0] diry,
        output pen_down,
        output wire done,
        output [2:0] state,
        output [4:0] idx
    );
    reg draw_rst, draw_enable;
    wire step_done, num_done;
    wire [7:0] start_x, start_y;
    wire [7:0] end_x, end_y;
    wire pen;
    reg pen_down, next_pen_down;
    reg [2:0] state, next_state;
    reg [4:0] idx, next_idx;
    reg [26:0] count, next_count;

    parameter SETUP = 3'b000;
    parameter PEN_DOWN = 3'b001;
    parameter DRAW_RST = 3'b010;
    parameter MOVE = 3'b011;
    parameter FINISH = 3'b100;

    always@(posedge clk)begin
        if(rst)begin
            state <= SETUP;
            count <= 27'd0;
            idx <= 4'd0;
            pen_down = 1'b0;
        end
        else begin
            if(enable)begin
                state <= next_state;
                count <= next_count;
                idx <= next_idx;
                pen_down <= next_pen_down;
            end
            else begin
                state <= SETUP;
                count <= 27'd0;
                idx <= 4'd0;
                pen_down = 1'b0; 
            end
        end
    end
    always@(*)begin
        case(state)
            SETUP:begin
                draw_rst = 1'b0;
                draw_enable = 1'b0;
                next_count = 27'd0;
                next_idx = 5'd0;
                next_state = PEN_DOWN;
                next_pen_down = pen_down;
            end
            PEN_DOWN:begin
                draw_rst = 1'b0;
                draw_enable = 1'b0;
                next_idx = idx;
                next_pen_down = pen;
                if(count >= 27'd199999999)begin
                    next_count = 27'd0;
                    next_state = DRAW_RST;
                end
                else begin
                    next_count = count + 27'd1;
                    next_state = PEN_DOWN;
                end
            end
            DRAW_RST:begin
                draw_rst = 1'b1;
                draw_enable = 1'b1;
                next_idx = idx;
                next_pen_down = pen_down;
                if(count >= 27'd600000)begin
                    next_count = 27'd0;
                    next_state = MOVE;
                end
                else begin
                    next_count = count + 27'd1;
                    next_state = DRAW_RST;
                end
            end
            MOVE:begin
                draw_rst = 1'b0;
                draw_enable = 1'b1;
                next_count = 27'd0;
                next_pen_down = pen_down;
                if(step_done)begin
                    if(end_x == 8'd0 && end_y == 8'd0)begin
                        next_idx = 5'd0;
                        next_state = FINISH;
                    end
                    else begin
                        next_idx = idx + 5'd1;
                        next_state = PEN_DOWN;
                    end
                end
                else begin
                    next_state = MOVE;
                    next_idx = idx;
                end
            end
            FINISH:begin
                draw_rst = 1'b0;
                draw_enable = 1'b0;
                next_count = 27'd0;
                next_idx = 5'd0;
                next_pen_down = pen_down;
                next_state = FINISH;
            end
        endcase
    end
    assign done = (state == FINISH) ? 1'b1 : 1'b0;
    draw_line d0(dclk, draw_rst, draw_enable, start_x, start_y, end_x, end_y, dirx, diry, step_done);
    number n0(idx, select, start_x, start_y, end_x, end_y, pen);
endmodule
