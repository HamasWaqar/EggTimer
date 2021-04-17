`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: Audio
// Project Name: Egg Timer
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: plays a multitone audio once the timer hits 00:00. Also, the user can choose from 5 tones ranging at various frequencies
//
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This concept was based on tutorial my partner and I completed in the begining of the semester to learn vivado. The tutorial
// can be found at https://www.fpga4fun.com/MusicBox2.html 
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
        IDEA: 
        
        Lets explain this idea using the BCD Digits. Let say the counter is created that is incrementing from 0 to 10000 at a frequncy of x
        
        854 856
        The ones digit will be incrementing at a frequency of x
        The tens digit will be incrementing at a frequency of x/10
        The hundred digit will be incrementing at a frequency of x/100
        The thousand digit will be incrementing at a frequency of x/1000
        and so on. 
        
        Therefore, as the digit place increases, the frequency of incrementing will decrease by a factor of 10^(n-10)
        
        Applying the same concept on the binary number where the bit's toggling frequnecy will be decreasing by a factor of 2^(n-1) 
        as the digit place increases
        
        In our case, the LSB from a 30 bit sound_tone will be toggling at a frequecy of 5 MHz while the MSB will be toggling about the frequency
        of 0.0093 Hz. Choosing the differnet binarny bit place will result produce a different frequency. Rememver, the least significant bits
        will be toggling at a high frequnecy and the most significant bits will be toggling at a low freqency. 
        
        The audible frequncy range can be determined in the range of Bit 9 to Bit 23 where the frequencies are generated range from
        1.19 Hz to 19.5 KHz. However, ussually its best to choose bits from the middle as 19.5 KHz is a really high pitch noise - so the
        bit range is anywhere from bit 14 to bit 23 that generates frequencies at 610.35 Hz to 1.19 Hz.
        
        Choosing a range of bots between bit 14 to bit 23 can result in multitone frequency if the audio is incremented through the tone
    */
  reg [29:0] sound_tone;
  reg [15:0] counter;
  reg [14:0] clkdivider;
  
  // High frequency tone that increases only
  function reg high_freq_sound;
      input [29:0] sound_tone;
      begin
          high_freq_sound = sound_tone [20:16];
      end
  endfunction
  
  // Low Frequency tone that increases only
  function reg low_freq_sound;
      input [29:0] sound_tone;
      begin
          low_freq_sound = sound_tone [23:19];
      end
  endfunction
  
  // Low frequency tone that increases and decreases
  function reg low_freq_sound_ramp;
      input [29:0] sound_tone;
      begin
          low_freq_sound_ramp = (sound_tone [24]) ? sound_tone [23:19] : ~sound_tone [23:19];
      end
  endfunction
  
  // High frequency tone that increases and decreases
  function reg high_freq_sound_ramp;
      input [29:0] sound_tone;
      begin
          high_freq_sound_ramp = (sound_tone [21]) ? sound_tone [20:16] : ~sound_tone [20:16];
      end
  endfunction
  
  /*
    Case statement to choose between the desired tone via a switch. Depending on the tone selected, a clock divider is set with a different 
    values. The purpose of the clock divider is to prolong the tunes such atleast a full period of the tune frequnecy square wave is completed 
    so produce a sound. Though experimentation, it was determined a audio has not been produced if atleast a full square wave is created. Plus,
    it increments the tone frequnecy at a specific values such that certain tone frequncies are being played. 
    
    Note: there are five tones the user can choose where tone 5 is the merger of the low_freq_sound_ramp tone and high_freq_sound_ramp tone 
    as it alternates among a two tones at a set period of time.
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
    
    /*
        At every rising edge of a 5MHz clk, the sound_tone is incremented. This allows the tune freuqency to increase each rising edge.
        Also, the counter is decremented at every risig edge polonging the duration a tune is played. As a counter hits zero,
        a new tones plays. 
    */
    always @(posedge pulse_5MHz) begin 
          sound_tone <= sound_tone + 1;
          if (endtime && ~endsound) begin
               if(counter == 0)
                   counter <= clkdivider;
                else 
                    counter <= counter-1;
          end
     end
    
   //When every a counter hit zero, a new tone is played in the speaker
    always @(posedge pulse_5MHz) begin
        if(counter==0) 
            AUD_PWM <= ~AUD_PWM;
    end
    
    
  assign AUD_SD = 1'b1;
endmodule
