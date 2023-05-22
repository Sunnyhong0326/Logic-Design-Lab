`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 10:19:29
// Design Name: 
// Module Name: draw_line
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


module draw_line(
    input clk,
    input rst,
    input enable,
    input [7:0] startx,
    input [7:0] starty,
    input [7:0] endx,
    input [7:0] endy,
    output reg [1:0] dirx, // 2'b10 left, 2'b01 right, 2'b00 stop
    output reg [1:0] diry, // 2'b10 foward, 2'b01 backward, 2'b00 stop
    output wire done
    );
    reg [1:0] next_dirx, next_diry;
    reg [7:0] cur_x, cur_y, next_cur_x, next_cur_y;
    reg [1:0] state, next_state;

    parameter SETUP = 2'b00;
    parameter MOVE = 2'b01;
    parameter FINISH = 2'b10;

    always@(posedge clk)begin
        if(rst)begin
            state <= SETUP;
            dirx <= 2'b00;
            diry <= 2'b00;
        end
        else begin
            if(enable)begin
                state <= next_state;
                dirx <= next_dirx;
                diry <= next_diry;
                cur_x <= next_cur_x;
                cur_y <= next_cur_y;
            end
            else begin
                state <= SETUP;
                dirx <= 2'b00;
                diry <= 2'b00;
                cur_x <= 8'd0;
                cur_y <= 8'd0;
            end
        end
    end
    always@(*)begin
        case(state)
            SETUP:begin
                next_state = MOVE;
            end
            MOVE:begin
                if(cur_x == endx && cur_y == endy)next_state = FINISH;
                else next_state = MOVE;
            end
            FINISH:begin
                next_state = FINISH;
            end
        endcase
    end
    always@(*)begin
        case(state)
            SETUP:begin
                next_cur_x = startx;
                next_dirx = 2'b00;
            end
            MOVE:begin
                if(cur_x != endx)begin
                    if(cur_x < endx)begin
                        next_dirx = 2'b01;
                        next_cur_x = cur_x + 8'd1;
                    end
                    else begin
                        next_dirx = 2'b11;
                        next_cur_x = cur_x - 8'd1;
                    end
                end
                else begin
                    next_dirx = 2'b00;
                    next_cur_x = cur_x;
                end
            end
            FINISH:begin
                next_dirx = 2'b00;
                next_cur_x = cur_x;
            end
        endcase
    end
    always@(*)begin
        case(state)
            SETUP:begin
                next_cur_y = starty;
                next_diry = 2'b00;
            end
            MOVE:begin
                if(cur_y != endy)begin
                    if(cur_y < endy)begin
                        next_diry = 2'b01;
                        next_cur_y = cur_y + 8'd1;
                    end
                    else begin
                        next_diry = 2'b11;
                        next_cur_y = cur_y - 8'd1;
                    end
                end
                else begin
                    next_diry = 2'b00;
                    next_cur_y = cur_y;
                end
            end
            FINISH:begin
                next_diry = 2'b00;
                next_cur_y = cur_y;
            end
        endcase
    end
    assign done = (state == FINISH) ? 1'b1 : 1'b0;
endmodule
