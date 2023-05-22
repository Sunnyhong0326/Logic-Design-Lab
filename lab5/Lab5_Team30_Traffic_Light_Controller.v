`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output reg [2:0] hw_light;
output reg [2:0] lr_light;
reg [6:0] cycle, nxt_cycle;
reg [2:0] state, nxt_state; 
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always @ (posedge clk) begin
if (rst_n == 1'b0) begin
    cycle <= 7'd0;
    state <= S0;
    end
else begin
    cycle <= nxt_cycle;
    state <= nxt_state;
    end
end

always @ (*) begin
case(state)
S0: begin
    hw_light = 3'b100;
    lr_light = 3'b001;
    if(cycle == 7'd80) begin
        if(lr_has_car) begin
            nxt_cycle = 7'd0;
            nxt_state = S1;
            end
        else begin
            nxt_cycle = cycle;
            nxt_state = S0;
            end
        end
    else begin
        nxt_cycle = cycle + 7'd1;  
        nxt_state = S0;
        end
    end
S1: begin
    hw_light = 3'b010;   
    lr_light = 3'b001;
    if(cycle == 7'd20) begin
        nxt_cycle = 7'd0;
        nxt_state = S2;
        end
    else begin
        nxt_cycle = cycle + 7'd1;
        nxt_state = S1;
        end
    end
S2: begin
    hw_light = 3'b001;
    lr_light = 3'b001;
    nxt_state = S3;
    nxt_cycle = 7'd0;
    end
S3: begin
    hw_light = 3'b001;
    lr_light = 3'b100;
    if(cycle == 7'd80) begin
        nxt_cycle = 7'd0;
        nxt_state = S4;
        end
    else begin
        nxt_cycle = cycle + 7'd1;
        nxt_state = S3;
        end
    end
S4: begin
    hw_light = 3'b001;
    lr_light = 3'b010;
    if(cycle == 7'd20) begin
        nxt_cycle = 7'd0;
        nxt_state = S5;
        end
    else begin
        nxt_cycle = cycle + 7'd1;
        nxt_state = S4;
        end
    end
S5: begin
    hw_light = 3'b001;
    lr_light = 3'b001;
    nxt_state = S0;
    nxt_cycle = 7'd0;
    end
endcase
end

endmodule
