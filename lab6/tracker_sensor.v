    `timescale 1ns/1ps
module tracker_sensor(clk, reset, left_signal, right_signal, mid_signal, state);
    input clk;
    input reset;
    input left_signal, right_signal, mid_signal;//input = 1, senses white input = 0, senses black
    output reg [2:0] state;
    reg [2:0] next_state;

    always@(posedge clk)begin
        if(reset)state <= 3'b000;
        else state <= next_state;
    end
    // [TO-DO] Receive three signals and make your own policy.
    // Hint: You can use output state to change your action.
    always@(*)begin
        next_state = state;
        case({left_signal, mid_signal, right_signal})
            3'b111:begin
                next_state = 3'b000;// straight
                //if(state == 3'b001||state == 3'b010)next_state = state;
            end
            3'b001:begin
                next_state = 3'b001;// turn big right
            end
            3'b100:begin
                next_state = 3'b010;// turn big left
            end
            3'b011:begin
                next_state = 3'b011;// turn right
            end 
            3'b110:begin
                next_state = 3'b100;// turn left
            end
            3'b000:begin
                next_state = state;
            end
            3'b010:next_state = 3'b000;// trivial
            3'b101:next_state = 3'b000;// trivial
            default: next_state = state;
        endcase
    end
endmodule
