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
    input pulse_17MHz,
    input reset,
    //input endtime,
    input [3:0] audioselection,
    output reg AUD_PWM,
    output AUD_SD
    );
    
    reg [14:0] counter = 0;
    reg [29:0] sound_tone;
    
    /*
        0-9 --> 
        10-99 -->
    
    */
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
            high_freq_sound_ramp = (sound_tone [21]) ? sound_tone [21:15] : ~sound_tone [20:16];
        end
    endfunction
    
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
    
      always @(posedge pulse_17MHz) begin 
            sound_tone <= sound_tone + 1;
            if(counter == 0)
               counter <= clkdivider;
            else 
                counter <= counter-1;
       end
      
     always @(posedge pulse_17MHz) if(counter==0) AUD_PWM <= ~AUD_PWM;
     
     /* 
      always @(posedge pulse_17MHz) begin
        if (reset)
            AUD_PWM <= 0;
        else begin
           if (counter==0)
               AUD_PWM <= ~AUD_PWM; 
            
            if(endtime) begin
                if (counter==0)
                    AUD_PWM <= ~AUD_PWM;
            end
            
        end
      end
      */
      
    assign AUD_SD = 1'b1;
endmodule
