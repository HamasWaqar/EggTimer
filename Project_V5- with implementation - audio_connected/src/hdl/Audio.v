`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2021 12:31:27 PM
// Design Name: 
// Module Name: Audio
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


module Audio(
    input pulse_5MHz,
    input reset,
    input endtime,
    input endsound,
    input [2:0] audioselection,
    output reg AUD_PWM,
    output AUD_SD
    );
    
      /*
      [24: 0] Bit 25 will be alternating at the the frequency of 1 Hz... as 17 MHz/1MHz = 1677216 with is 100000000000000000000000
              As the bit decreases, the freqency increases by a factor of 1 Hz
      
      Increasing to [29:0] where bit [29] switch between the two modes around evenry 30 sed
      
      need to  
      1111 (7) - 0011 (3) = 1100
    */
  reg [29:0] sound_tone;
  reg [15:0] counter;
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
  /*
  
  */
  always @ (*) begin
      case (audioselection)
          0: clkdivider = {2'b01, high_freq_sound(sound_tone), 6'b000000};
          1: clkdivider = {2'b01, low_freq_sound(sound_tone), 6'b000000};
          2: clkdivider = {2'b01, low_freq_sound_ramp(sound_tone), 6'b000000};
          3: clkdivider = {2'b01, high_freq_sound_ramp(sound_tone), 6'b000000};
          4: clkdivider = {2'b01, ((sound_tone[27]) ? low_freq_sound_ramp(sound_tone) : high_freq_sound_ramp(sound_tone)), 6'b000000};
          default: clkdivider = {2'b01, high_freq_sound(sound_tone), 6'b000000};
      endcase
  
  end
  
    always @(posedge pulse_5MHz) begin 
          sound_tone <= sound_tone + 1;
          if (endtime && ~endsound) begin
               if(counter == 0)
                   counter <= clkdivider;
                else 
                    counter <= counter-1;
          end
     end
    
   
    always @(posedge pulse_5MHz) if(counter==0) AUD_PWM <= ~AUD_PWM;
    
    
  assign AUD_SD = 1'b1;
endmodule