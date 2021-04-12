`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Design Name: Egg Timer
// Module Name: clock
// Project Name: 
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Clock Divider - Output two syncronous clocks at 500 Hz and 1 Hz fro the BCD Display and the 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK100MHZ,
    input reset,
    input enable,
    input [3:0] audio_sounds,
    output reg AUD_PWM,
    output AUD_SD
    );  
    
    parameter clk_counter_milisec = 2500;
    
    wire clk_5MHz;
    reg clk_2dot5MHz = 0;
    reg clk_100Hz = 0;
    reg [15:0] counter;
    reg clk_1ms = 0;
    
    
      clk_wiz_0 demo_clk(
      // Clock out ports
      .clk_out1(clk_5MHz),     // output clk_out1
     // Clock in ports
      .clk_in1(CLK100MHZ));      // input clk_in1
      
      /*
        [24: 0] Bit 25 will be alternating at the the frequency of 1 Hz... as 17 MHz/1MHz = 1677216 with is 100000000000000000000000
                As the bit decreases, the freqency increases by a factor of 1 Hz
        
        Increasing to [29:0] where bit [29] switch between the two modes around evenry 30 sed
        
        need to  
        1111 (7) - 0011 (3) = 1100
      */
    reg [29:0] sound_tone;
    
    reg [14:0] clkdivider;
    
    function reg high_freq_sound;
        input [29:0] sound_tone;
        begin
            high_freq_sound = sound_tone [20:16];
        end
    endfunction
    
    function reg low_freq_sound;
        input [29:0] sound_tone;
        begin
            low_freq_sound = sound_tone [23:19];
        end
    endfunction
    
    function reg low_freq_sound_ramp;
        input [29:0] sound_tone;
        begin
            low_freq_sound_ramp = (sound_tone [24]) ? sound_tone [23:19] : ~sound_tone [23:19];
        end
    endfunction
    
    function reg high_freq_sound_ramp;
        input [29:0] sound_tone;
        begin
            high_freq_sound_ramp = (sound_tone [21]) ? sound_tone [20:16] : ~sound_tone [20:16];
        end
    endfunction
    
    always @ (*) begin
        case (audio_sounds)
            0: clkdivider = {2'b01, high_freq_sound(sound_tone), 6'b000000};
            1: clkdivider = {2'b01, low_freq_sound(sound_tone), 6'b000000};
            2: clkdivider = {2'b01, low_freq_sound_ramp(sound_tone), 6'b000000};
            3: clkdivider = {2'b01, high_freq_sound_ramp(sound_tone), 6'b000000};
            4: clkdivider = {2'b01, ((sound_tone[27]) ? low_freq_sound_ramp(sound_tone) : high_freq_sound_ramp(sound_tone)), 6'b000000};
            default: clkdivider = {2'b01, high_freq_sound(sound_tone), 6'b000000};
        endcase
    
    end
    
      always @(posedge clk_5MHz) begin 
            sound_tone <= sound_tone + 1;
            if(counter == 0)
               counter <= clkdivider;
            else 
                counter <= counter-1;
       end
      
     
      always @(posedge clk_5MHz) if(counter==0) AUD_PWM <= ~AUD_PWM;
      
      
    assign AUD_SD = 1'b1;
endmodule