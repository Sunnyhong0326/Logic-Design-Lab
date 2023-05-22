`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/12 15:39:32
// Design Name: 
// Module Name: num2
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


module num2(
    input [4:0] idx,
    input enable,
    output reg [7:0] start_x,
    output reg [7:0] start_y,
    output reg [7:0] end_x,
    output reg [7:0] end_y,
    output reg pen_down
);
    always@(*)begin
        if(enable)begin
            case(idx)
            5'd0:begin
                start_x = 8'd0;
                start_y = 8'd0;
                end_x = 8'd60;
                end_y = 8'd40;
                pen_down = 1'b0;
            end
            5'd1:begin
                start_x = 8'd60;
                start_y = 8'd40;
                end_x = 8'd60;
                end_y = 8'd120;
                pen_down = 1'b1;
            end
            5'd2:begin
                start_x = 8'd60;
                start_y = 8'd120;
                end_x = 8'd120;
                end_y = 8'd120;
                pen_down = 1'b1;
            end
            5'd3:begin
                start_x = 8'd120;
                start_y = 8'd120;
                end_x = 8'd120;
                end_y = 8'd40;
                pen_down = 1'b1;
            end
            5'd4:begin
                start_x = 8'd120;
                start_y = 8'd40;
                end_x = 8'd180;
                end_y = 8'd40;
                pen_down = 1'b1;
            end
            5'd5:begin
                start_x = 8'd180;
                start_y = 8'd40;
                end_x = 8'd180;
                end_y = 8'd120;
                pen_down = 1'b1;
            end
            5'd6:begin
                start_x = 8'd180;
                start_y = 8'd120;
                end_x = 8'd0;
                end_y = 8'd0;
                pen_down = 1'b0;
            end
        endcase
        end
        else begin
            start_x = 8'd0;
            start_y = 8'd0;
            end_x = 8'd0;
            end_y = 8'd0;
            pen_down = 1'b0;
        end
    end
endmodule
