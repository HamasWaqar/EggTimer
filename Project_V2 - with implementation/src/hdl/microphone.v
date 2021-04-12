`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2021 12:00:28 PM
// Design Name: 
// Module Name: microphone
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


module microphone(
    input pulse_2dot5MHz,
    input pulse_100Hz,
    input reset,
    input enable_mike,
    input M_DATA,
    output M_CLK,
    output M_LRSEL,
    output reg [15:0] LED
    );
    
     reg [3:0] sampling_period;
     reg sampled_pwm_input;
	 
	 /*
		samples the data at 1 Hz...
	 */
     
     always @ (posedge pulse_100Hz or posedge reset) begin
        if (reset || ~enable_mike) begin
            sampling_period <= 0;
            sampled_pwm_input <= 0;
        end else if ( sampling_period >= 10 ) begin
            sampling_period <= 0;
            sampled_pwm_input <= M_DATA;
        end else
            sampling_period <=  sampling_period + 1;
     end
     
     assign M_CLK = pulse_2dot5MHz;
     assign M_LRSEL = 1'b1;
     
    /*
	Phase shift the LEDs by one bit to the left once a new input is sampled  
	*/
     reg [3:0] led_counter = 0;
     
     always @ (posedge pulse_100Hz or posedge reset) begin
             if (reset) begin
                 led_counter <= 0;
                 LED <= 0;
             end else if ( led_counter >= 10 ) begin
                 LED <= LED << 1;
                 LED[0] <= sampled_pwm_input;
                 led_counter <= 0;
             end else
                 led_counter <=  led_counter + 1;
    end
endmodule
