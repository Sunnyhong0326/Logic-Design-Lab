`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/11 00:36:58
// Design Name: 
// Module Name: number
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


module number(
    input [4:0] idx, 
    input [3:0] select,
    output wire [7:0] start_x,
    output wire [7:0] start_y,
    output wire [7:0] end_x,
    output wire [7:0] end_y,
    output wire pen_down
    );
    reg [9:0] num_enable;
    wire [7:0] tmp_startx [0:9];
    wire [7:0] tmp_starty [0:9];
    wire [7:0] tmp_endx [0:9];
    wire [7:0] tmp_endy [0:9];
    wire [9:0] tmp_pen;
    always@(*)begin
        num_enable = 10'd0;
        case(select)
            4'd0:num_enable[0] = 1'b1;
            4'd1:num_enable[1] = 1'b1;
            4'd2:num_enable[2] = 1'b1;
            4'd3:num_enable[3] = 1'b1;
            4'd4:num_enable[4] = 1'b1;
            4'd5:num_enable[5] = 1'b1;
            4'd6:num_enable[6] = 1'b1;
            4'd7:num_enable[7] = 1'b1;
            4'd8:num_enable[8] = 1'b1;
            4'd9:num_enable[9] = 1'b1;
        endcase
    end
    num0 n0(idx, num_enable[0], tmp_startx[0], tmp_starty[0], tmp_endx[0], tmp_endy[0], tmp_pen[0]);
    num1 n1(idx, num_enable[1], tmp_startx[1], tmp_starty[1], tmp_endx[1], tmp_endy[1], tmp_pen[1]);
    num2 n2(idx, num_enable[2], tmp_startx[2], tmp_starty[2], tmp_endx[2], tmp_endy[2], tmp_pen[2]);
    num3 n3(idx, num_enable[3], tmp_startx[3], tmp_starty[3], tmp_endx[3], tmp_endy[3], tmp_pen[3]);
    num4 n4(idx, num_enable[4], tmp_startx[4], tmp_starty[4], tmp_endx[4], tmp_endy[4], tmp_pen[4]);
    num5 n5(idx, num_enable[5], tmp_startx[5], tmp_starty[5], tmp_endx[5], tmp_endy[5], tmp_pen[5]);
    num6 n6(idx, num_enable[6], tmp_startx[6], tmp_starty[6], tmp_endx[6], tmp_endy[6], tmp_pen[6]);
    num7 n7(idx, num_enable[7], tmp_startx[7], tmp_starty[7], tmp_endx[7], tmp_endy[7], tmp_pen[7]);
    num8 n8(idx, num_enable[8], tmp_startx[8], tmp_starty[8], tmp_endx[8], tmp_endy[8], tmp_pen[8]);
    num9 n9(idx, num_enable[9], tmp_startx[9], tmp_starty[9], tmp_endx[9], tmp_endy[9], tmp_pen[9]);
    assign start_x = tmp_startx[0] | tmp_startx[1] | tmp_startx[2] | tmp_startx[3] | tmp_startx[4] | tmp_startx[5] | tmp_startx[6] | tmp_startx[7] | tmp_startx[8] | tmp_startx[9];
    assign start_y = tmp_starty[0] | tmp_starty[1] | tmp_starty[2] | tmp_starty[3] | tmp_starty[4] | tmp_starty[5] | tmp_starty[6] | tmp_starty[7] | tmp_starty[8] | tmp_starty[9];
    assign end_x = tmp_endx[0] | tmp_endx[1] | tmp_endx[2] | tmp_endx[3] | tmp_endx[4] | tmp_endx[5] | tmp_endx[6] | tmp_endx[7] | tmp_endx[8] | tmp_endx[9];
    assign end_y = tmp_endy[0] | tmp_endy[1] | tmp_endy[2] | tmp_endy[3] | tmp_endy[4] | tmp_endy[5] | tmp_endy[6] | tmp_endy[7] | tmp_endy[8] | tmp_endy[9];
    assign pen_down = tmp_pen[0] | tmp_pen[1] | tmp_pen[2] | tmp_pen[3] | tmp_pen[4] | tmp_pen[5] | tmp_pen[6] | tmp_pen[7] | tmp_pen[8] | tmp_pen[9];
endmodule