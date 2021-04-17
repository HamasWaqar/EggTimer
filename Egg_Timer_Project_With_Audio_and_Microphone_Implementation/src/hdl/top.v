`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: Top
// Project Name: Egg Timer
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Top Module to the Eggtimer
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input CLK100MHZ,
    input cook_time,
    input minutes_up,
    input seconds_up,
    input start,
    input reset,
    input enable_timer,
    output [6:0] seg,
    output [7:0] AN,
    output M_CLK,
    input M_DATA,
    output M_LRSEL,
    output [15:0] LED,
    input enable_mike,
    output AUD_PWM,
    output AUD_SD,
    input [2:0] audioselection,
    input endsound
    );  
    
    wire pulse_500Hz, pulse_1Hz, pulse_2dot5MHz, pulse_100KHz, pulse_25MHz, pulse_5MHz;
    
    // Generating the required clock frequencies
    clock timestone (
        .CLK100Mhz(CLK100MHZ),
        .reset (reset),
        .pulse_500Hz (pulse_500Hz),
        .pulse_1Hz (pulse_1Hz),
        .pulse_2dot5MHz (pulse_2dot5MHz),
        .pulse_100KHz (pulse_100KHz),
        .pulse_5MHz(pulse_5MHz)
    );
    
        
        
    wire debounce_minutes, debounce_seconds;
    //wire enable_timer_countdown, enable_load;
    wire [3:0] load_second_ones;
    wire [3:0] load_second_tens;
    wire [3:0] load_minute_ones;
    wire [3:0] load_minute_tens;
    wire [3:0] second_ones;
    wire [3:0] second_tens;
    wire [3:0] minute_ones;
    wire [3:0] minute_tens;

    // syncronizing the minute input through a debounce
    debounce soulstone (
        .pulse_1Hz (pulse_1Hz),
        .minutes_seconds_up (minutes_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_minutes)
    );

    // syncronizing the second input through a debounce
    debounce realitystone (
        .pulse_1Hz (pulse_1Hz),
        .minutes_seconds_up (seconds_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_seconds)
    );
    
    //configures the operating state of the egg timer plus a upcounter to adjust the start time
    egg_timer_fsm mindstone (
        .pulse_1Hz (pulse_1Hz),
        .pulse_500Hz (pulse_500Hz),
        .cook_time (cook_time),
        .minutes_debounce_up (debounce_minutes),
        .seconds_debounce_up (debounce_seconds),
        .start (start),
        .reset (reset),
        .enable_timer (enable_timer),
        .enable_load (enable_load),
        .enable_timer_countdown (enable_timer_countdown),
        .load_second_ones (load_second_ones),
        .load_second_tens (load_second_tens), 
        .load_minute_ones (load_minute_ones),
        .load_minute_tens (load_minute_tens)
    ); 
    
    wire endtime;
    
    //timer that loads the starting time in the egg timer or counts down depending on the operating state
    timer spacestone(
        .pulse_1Hz (pulse_1Hz),
        .reset (reset),
        .load_min_tens (load_minute_tens),
        .load_min_ones (load_minute_ones),
        .load_sec_ones (load_second_ones),
        .load_sec_tens (load_second_tens),
        .load (enable_load),
        .enable (enable_timer_countdown),
        .enable_timer (enable_timer),
        .endtime (endtime),
        .second_ones (second_ones),
        .second_tens (second_tens),
        .minute_ones (minute_ones),
        .minute_tens (minute_tens)
        );
        
     //load the time into the BCD Display    
     bcdto7segment_display powerstone(
        .pulse_500Hz (pulse_500Hz),
        .sec_digit1 (second_ones),
        .sec_digit2 (second_tens),
        .min_digit1 (minute_ones),
        .min_digit2 (minute_tens),
        .seg (seg),
        .AN (AN)
      );
      
      /*
      Samples the audio from the microphone at 100 KHz and display the every 10000 sample on the LED. 
      This results in the LEDs following the rythm of the music
      
      Audio Sampling will be determined using 1 bit per sample resulting in the two quantization amplitude levels. In other words,
      the sample will detect the is the audio is on or not at that second of sampling.
      */
      microphone starlord(
          .pulse_2dot5MHz (pulse_2dot5MHz),
          .pulse_100KHz (pulse_100KHz),
          .reset (reset),
          .enable_mike (enable_mike),
          .M_DATA (M_DATA),
          .M_CLK (M_CLK),
          .M_LRSEL (M_LRSEL),
          .LED (LED)
      );
      
        /*
            A multitone squarewave audio is played when the timer ends (ie. 00 : 00) 
            There are 5 programable tones that the user can choose from ranging at different frequnecies.
        */
      
      Audio hulksmash(
          .pulse_5MHz (pulse_5MHz),
          .reset (reset),
          .endsound(endsound),
          .endtime (((second_ones == 0) && (second_tens == 0) && (minute_ones == 0) && (minute_tens == 0))),
          .audioselection (audioselection),
          .AUD_PWM (AUD_PWM),
          .AUD_SD (AUD_SD)
      );

endmodule