`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/29 23:44:50
// Design Name: 
// Module Name: servo_motor
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

module servo_motor(
  input clk,
  input rst,
  input write,
  output reg PWM
  );
  
wire [20:0] move = (write) ? 21'd200000 : 21'd150000;
reg [20:0] count;
    
always @ (posedge clk) begin
    if (rst == 1'b1 || count == 21'd2000000) 
		count <= 21'b0;
	else
		count <= count + 1'b1;
	end
	
always @ (*) begin
	if (count < move)
		begin
		PWM = 1'b1;
		end
	else 
		begin
		PWM = 1'b0;
		end
	end	

endmodule