`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: microphone
// Project Name: Egg Timer
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Samples the audio from the microphone at 100 KHz and display the every 10000 sample on the LED. This results in the Microphone
// following the rythm of the music
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
    input pulse_100KHz,
    input reset,
    input enable_mike,
    input M_DATA,
    output M_CLK,
    output M_LRSEL,
    output reg [15:0] LED
    );
    
     /*
      Samples the audio from the microphone at 100 KHz and display the every 10000 sample on the LED. 
      This results in the LEDs following the rythm of the music
      
      Audio Sampling will be determined using 1 bit per sample resulting in the two quantization amplitude levels. In other words,
      the sample will detect the is the audio is on or not at that second of sampling.
      
      Note, a typical audio frequency range that humans can hear is from 20 Hz to 20 KHz. A sampling frequency of 100 KHz was choosen as it
      is well above the 2 * the bandwidth of the max audible frequency of 20 KHz, satisfying Nyquist Frequency Conditions
      
      */
     reg sampled_pwm_input;
     
     always @ (posedge pulse_100KHz or posedge reset) begin
        if (reset || ~enable_mike) begin
            sampled_pwm_input <= 0;
        end else begin
            sampled_pwm_input <= M_DATA;
        end
     end
     
     assign M_CLK = pulse_2dot5MHz;
     assign M_LRSEL = 1'b1;
     
    /*
	   Since LEDs at 100 KHz will just be a solid line, a LED will be adjusted every 10000 samples.
	   This results in the LED sampling the audio every 1 Hz or 1 Second.
	   
	   Phase shift the LEDs by one bit to the left once a new input is sampled which will be stored into LED 0 
	*/
     reg [21:0] led_counter = 0;
     
     always @ (posedge pulse_100KHz or posedge reset) begin
             if (reset || ~enable_mike) begin
                 led_counter <= 0;
                 LED <= 0;
             end else if ( led_counter >= 10000 ) begin
                 LED <= LED << 1;
                 LED[0] <= sampled_pwm_input;
                 led_counter <= 0;
             end else
                 led_counter <=  led_counter + 1;
    end
endmodule
