module Top(
    input clk,
    input rst,
    input echo,
    input left_signal,
    input right_signal,
    input mid_signal,
    input switchsonar,
    output trig,    
    output left_motor,// left pwm
    output reg [1:0]left,// foward backward
    output right_motor,// right pwm
    output reg [1:0]right,// foward backward
    output LED, 
    output [2:0]lmr_LED
);
    wire [1:0] pwm;
    wire [2:0] state;
    wire Rst, rst_pb, stop, stop_tmp;
    debounce d0(rst_pb, rst, clk);
    onepulse d1(rst_pb, clk, Rst);
    
    motor A(
        .clk(clk),
        .rst(Rst),
        .mode(state),
        .pwm(pwm)
    );

    sonic_top B(
        .clk(clk), 
        .rst(Rst), 
        .Echo(echo), 
        .Trig(trig),
        .stop(stop_tmp)
    );
    
    tracker_sensor C(
        .clk(clk), 
        .reset(Rst), 
        .left_signal(left_signal), 
        .right_signal(right_signal),
        .mid_signal(mid_signal), 
        .state(state)
       );

    always @(*) begin
        // [TO-DO] Use left and right to set your pwm
        if(stop)begin
            left = 2'b00;
            right = 2'b00;
        end
        else begin
            case(state)
            3'b000:begin// go straight
                left = 2'b10;
                right = 2'b10;
            end
            3'b001:begin// turn big right
                left = 2'b10;
                right = 2'b01;
            end
            3'b010:begin// turn big left
                left = 2'b01;
                right = 2'b10;
            end
            3'b011:begin// turn right
                left = 2'b10;
                right = 2'b10;
            end
            3'b100:begin// turn left
                left = 2'b10;
                right = 2'b10;
            end
            default:begin
                left = 2'b00;
                right = 2'b00;
            end
            endcase
        end
    end
    assign left_motor = pwm[1];
    assign right_motor = pwm[0];
    assign LED = (stop==1'b1)? 1'b1 : 1'b0;
    assign lmr_LED = {right_signal, mid_signal, left_signal};
    assign stop = (switchsonar==1'b1) ? stop_tmp : 1'b0;
endmodule

module debounce (pb_debounced, pb, clk);
    output pb_debounced; 
    input pb;
    input clk;
    reg [4:0] DFF;
    
    always @(posedge clk) begin
        DFF[4:1] <= DFF[3:0];
        DFF[0] <= pb; 
    end
    assign pb_debounced = (&(DFF)); 
endmodule

module onepulse (PB_debounced, clk, PB_one_pulse);
    input PB_debounced;
    input clk;
    output reg PB_one_pulse;
    reg PB_debounced_delay;

    always @(posedge clk) begin
        PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
        PB_debounced_delay <= PB_debounced;
    end 
endmodule

