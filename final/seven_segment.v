module SevenSegment(
    input clk, 
    input rst, 
    input [7:0] num,
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
                if(num >= 8'd100)display_num = 7'd0;
                else if(num >= 8'd90)display_num = num - 8'd90;
                else if(num >= 8'd80)display_num = num - 8'd80;
                else if(num >= 8'd70)display_num = num - 8'd70;
                else if(num >= 8'd60)display_num = num - 8'd60;
                else if(num >= 8'd50)display_num = num - 8'd50;
                else if(num >= 8'd40)display_num = num - 8'd40;
                else if(num >= 8'd30)display_num = num - 8'd30;
                else if(num >= 8'd20)display_num = num - 8'd20;
                else if(num >= 8'd10)display_num = num - 8'd10;
                else display_num = num;
            end
            4'b1101:begin
                //display_num = num /10;
                if(num >= 7'd100)display_num = 7'd0;
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
                display_num = 7'd10;
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