`timescale 1ns / 1ps

`define C4 32'd262 //C4_freq
`define D4 32'd294 //D4_freq
`define E4 32'd330 //E4_freq
`define F4 32'd349 //F4_freq
`define G4 32'd392 //G4_freq
`define A4 32'd440 //A4_freq
`define B4 32'd494 //B4_freq
`define C5 32'd523
`define D5 32'd587
`define E5 32'd659
`define F5 32'd698
`define G5 32'd784
`define A5 32'd880
`define B5 32'd988
`define C6 32'd1047
`define D6 32'd1175
`define E6 32'd1319
`define F6 32'd1397
`define G6 32'd1568
`define A6 32'd1760
`define B6 32'd1976
`define C7 32'd2093
`define D7 32'd2349
`define E7 32'd2637
`define F7 32'd2794
`define G7 32'd3136
`define A7 32'd3520
`define B7 32'd3951
`define C8 32'd4186
`define NM0 32'd20000 //slience (over freq.)

module Lab5_Team30_Music_fpga(
	input clk,
	input rst,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	output pmod_1,
	output pmod_2,
	output pmod_4
);
parameter DUTY_BEST = 10'd512;	//duty cycle=50%

parameter [8:0] KEY_CODES_W = 9'b0_0001_1101;	// W => 1D
parameter [8:0] KEY_CODES_S = 9'b0_0001_1011;	// S=> 1B
parameter [8:0] KEY_CODES_R = 9'b0_0010_1101;	// R => 2D
parameter [8:0] KEY_CODES_enter = 9'b0_0101_1010;	// enter => 5A

reg [31:0] BEAT_FREQ;
wire [31:0] freq;
wire [4:0] ibeatNum;
wire beatFreq;

reg [2:0] key;
wire [511:0] key_down;
wire [8:0] last_change;
wire been_ready;
wire half;

assign pmod_2 = 1'd1;	//no gain(6dB)
assign pmod_4 = 1'd1;	//turn-on

//Generate beat speed
PWM_gen btSpeedGen ( .clk(clk), 
					 .rst(rst),
					 .freq(BEAT_FREQ),
					 .duty(DUTY_BEST), 
					 .PWM(beatFreq)
);
	
//manipulate beat
PlayerCtrl playerCtrl_00 ( .clk(beatFreq),
						   .rst(rst),
						   .enter(key_down[KEY_CODES_enter]),
						   .r(key_down[KEY_CODES_R]),
						   .ibeat(ibeatNum),
						   .key(key),
						   .half(half)
);	
	
//Generate variant freq. of tones
Music music00 ( .ibeatNum(ibeatNum),
				.tone(freq)
);

// Generate particular freq. signal
PWM_gen toneGen ( .clk(clk), 
				  .rst(rst), 
				  .freq(freq),
				  .duty(DUTY_BEST), 
				  .PWM(pmod_1)
);

KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
 
always @ (*) begin
if(half)
    BEAT_FREQ = 32'd2; // 0.5 sec
else 
    BEAT_FREQ = 32'd1; // 1 sec
end

always @ (*) begin
	if(key_down[last_change] && been_ready)
		case (last_change)
			KEY_CODES_W : key = 3'b000;
			KEY_CODES_S : key = 3'b001;
			KEY_CODES_R : key = 3'b010;
			KEY_CODES_enter : key = 3'b011;
			default		  : key = 3'b100;
		endcase
	end

endmodule

module PlayerCtrl (
	input clk,
	input rst,
	input enter,
	input r,
	input [2:0] key,
	output reg [4:0] ibeat,
	output reg half
);
parameter BEATLEAGTH = 28;

reg direction, nxt_dir, nxt_half;
reg counter;

always @(posedge clk, posedge rst, posedge enter, posedge r) begin
	if (rst)begin
		ibeat <= 0;
		half <= 1'b0;
		direction <= 1'b1;
		counter <= 1'b0;
		end
    else if (enter) begin
        ibeat <= 0;
        half <= 1'b0;
        direction <= 1'b1;
        counter <= 1'b0;
        end
    else if (r)
        counter <= counter + 1'b1;
    else begin
        half <= nxt_half;
        direction <= nxt_dir;
        if (direction) begin
            if(ibeat < BEATLEAGTH)
                ibeat <= ibeat + 1;
            else 
                ibeat <= ibeat;
            end
        else begin
            if(ibeat > 5'd0)
                ibeat <= ibeat - 1;
            else 
                ibeat <= ibeat;
            end
        end    
end

always @ (*) begin
    case(key)      
    3'b000: begin // w
        nxt_dir = 1'b1; 
        nxt_half = half;
        end
    3'b001: begin // s
        nxt_dir = 1'b0;
        nxt_half = half;
        end
    3'b010: begin // r
        nxt_dir = direction;
        if(counter)
            nxt_half = 1'b0;
        else
            nxt_half = 1'b1;
        end
    3'b011: begin // enter
        nxt_dir = 1'b1;
        nxt_half = 1'b0;
        end
    default: begin
        nxt_dir = direction;
        nxt_half = half;
        end
    endcase
end

endmodule

module Music (
	input [4:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)		// 1/4 beat
		5'd0 : tone = `C4;
		5'd1 : tone = `D4;
		5'd2 : tone = `E4;
		5'd3 : tone = `F4;
		5'd4 : tone = `G4;
		5'd5 : tone = `A4;
		5'd6 : tone = `B4;
		5'd7 : tone = `C5;
		5'd8 : tone = `D5;
		5'd9 : tone = `E5;
		5'd10 : tone = `F5;
		5'd11 : tone = `G5;
		5'd12 : tone = `A5;
		5'd13 : tone = `B5;
		5'd14 : tone = `C6;
		5'd15 : tone = `D6;
		5'd16 : tone = `E6;
		5'd17 : tone = `F6;
		5'd18 : tone = `G6;
		5'd19 : tone = `A6;
		5'd20 : tone = `B6;
		5'd21 : tone = `C7;
		5'd22 : tone = `D7;
		5'd23 : tone = `E7;
		5'd24 : tone = `F7;
		5'd25 : tone = `G7;
		5'd26 : tone = `A7;
		5'd27 : tone = `B7;
		5'd28 : tone = `C8;
		default : tone = `NM0;
	endcase
end

endmodule

module PWM_gen (
    input wire clk,
    input wire rst,
	input [31:0] freq,
    input [9:0] duty,
    output reg PWM
);

wire [31:0] count_max = 100_000_000 / freq;
wire [31:0] count_duty = count_max * duty / 1024;
reg [31:0] count;
    
always @(posedge clk, posedge rst) begin
    if (rst) begin
        count <= 0;
        PWM <= 0;
    end else if (count < count_max) begin
        count <= count + 1;
		if(count < count_duty)
            PWM <= 1;
        else
            PWM <= 0;
    end else begin
        count <= 0;
        PWM <= 0;
    end
end

endmodule

module KeyboardDecoder(
	output reg [511:0] key_down,
	output wire [8:0] last_change,
	output reg key_valid,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
    );
    
    parameter [1:0] INIT			= 2'b00;
    parameter [1:0] WAIT_FOR_SIGNAL = 2'b01;
    parameter [1:0] GET_SIGNAL_DOWN = 2'b10;
    parameter [1:0] WAIT_RELEASE    = 2'b11;
    
	parameter [7:0] IS_INIT			= 8'hAA;
    parameter [7:0] IS_EXTEND		= 8'hE0;
    parameter [7:0] IS_BREAK		= 8'hF0;
    
    reg [9:0] key;		// key = {been_extend, been_break, key_in}
    reg [1:0] state;
    reg been_ready, been_extend, been_break;
    
    wire [7:0] key_in;
    wire is_extend;
    wire is_break;
    wire valid;
    wire err;
    
    wire [511:0] key_decode = 1 << last_change;
    assign last_change = {key[9], key[7:0]};
    
    KeyboardCtrl_0 inst (
		.key_in(key_in),
		.is_extend(is_extend),
		.is_break(is_break),
		.valid(valid),
		.err(err),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);
	
	OnePulse op (
		.signal_single_pulse(pulse_been_ready),
		.signal(been_ready),
		.clock(clk)
	);
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		state <= INIT;
    		been_ready  <= 1'b0;
    		been_extend <= 1'b0;
    		been_break  <= 1'b0;
    		key <= 10'b0_0_0000_0000;
    	end else begin
    		state <= state;
			been_ready  <= been_ready;
			been_extend <= (is_extend) ? 1'b1 : been_extend;
			been_break  <= (is_break ) ? 1'b1 : been_break;
			key <= key;
    		case (state)
    			INIT : begin
    					if (key_in == IS_INIT) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready  <= 1'b0;
							been_extend <= 1'b0;
							been_break  <= 1'b0;
							key <= 10'b0_0_0000_0000;
    					end else begin
    						state <= INIT;
    					end
    				end
    			WAIT_FOR_SIGNAL : begin
    					if (valid == 0) begin
    						state <= WAIT_FOR_SIGNAL;
    						been_ready <= 1'b0;
    					end else begin
    						state <= GET_SIGNAL_DOWN;
    					end
    				end
    			GET_SIGNAL_DOWN : begin
						state <= WAIT_RELEASE;
						key <= {been_extend, been_break, key_in};
						been_ready  <= 1'b1;
    				end
    			WAIT_RELEASE : begin
    					if (valid == 1) begin
    						state <= WAIT_RELEASE;
    					end else begin
    						state <= WAIT_FOR_SIGNAL;
    						been_extend <= 1'b0;
    						been_break  <= 1'b0;
    					end
    				end
    			default : begin
    					state <= INIT;
						been_ready  <= 1'b0;
						been_extend <= 1'b0;
						been_break  <= 1'b0;
						key <= 10'b0_0_0000_0000;
    				end
    		endcase
    	end
    end
    
    always @ (posedge clk, posedge rst) begin
    	if (rst) begin
    		key_valid <= 1'b0;
    		key_down <= 511'b0;
    	end else if (key_decode[last_change] && pulse_been_ready) begin
    		key_valid <= 1'b1;
    		if (key[8] == 0) begin
    			key_down <= key_down | key_decode;
    		end else begin
    			key_down <= key_down & (~key_decode);
    		end
    	end else begin
    		key_valid <= 1'b0;
			key_down <= key_down;
    	end
    end

endmodule

module OnePulse (
	output reg signal_single_pulse,
	input wire signal,
	input wire clock
	);
	
	reg signal_delay;

	always @(posedge clock) begin
		if (signal == 1'b1 & signal_delay == 1'b0)
		  signal_single_pulse <= 1'b1;
		else
		  signal_single_pulse <= 1'b0;

		signal_delay <= signal;
	end
endmodule
