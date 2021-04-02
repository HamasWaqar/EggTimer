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
    input cook_time,
    input minutes_up,
    input seconds_up,
    input start,
    input reset,
    input enable_egg_timer, 
    output enable_egg_timer_LED, 
    output enable_timer_LED,
    output [6:0] seg,
    output [7:0] AN
    );  

    wire pulse_1Hz, pulse_500Hz;

    clock timestone (
        .CLK100Mhz (CLK100MHZ),
        .reset (reset),
        .pulse_500Hz (pulse_500Hz),
        .pulse_1Hz (pulse_1Hz)
    );
    
    wire [3:0] load_sec_ones, load_sec_tens, load_min_ones, load_min_tens;
    wire [3:0] minute_tens, minute_ones, second_tens, second_ones;

    wire debounce_minutes, debounce_seconds;

    debounce soulstone (
        .pulse_1Hz (pulse_1Hz),
        .minutes_seconds_up (minutes_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_minutes)
    );

    debounce powerstone (
        .pulse_1Hz (pulse_1Hz),
        .minutes_seconds_up (seconds_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_seconds)
    );
    
    egg_timer_fsm mindstone (
        .pulse_1Hz (pulse_1Hz),
        .cook_time (cook_time),
        .minutes_debounce_up (debounce_minutes),
        .seconds_debounce_up (debounce_seconds),
        .start (start),
        .reset (reset),
        .enable_timer_cooktime (enable_timer_cooktime),
        .load_second_ones (load_sec_ones),
        .load_second_tens (load_sec_tens), 
        .load_minute_ones (load_min_ones),
        .load_minute_tens (load_min_tens)
    );

    wire enable_timer;
    assign enable_timer = (~enable_timer_cooktime && enable_egg_timer) ? 1'b1: 1'b0;
    assign enable_timer_LED = enable_timer;

    timer spacestone (
        .pulse_1Hz (pulse_1Hz),
        .reset (reset),
        .enable (enable_timer),
        .load_min_ones (load_min_ones),
        .load_sec_tens (load_sec_tens),
        .load_sec_ones (load_sec_ones),
        .load_min_tens (load_min_tens),
        .load (cook_time),
        .minute_tens (minute_tens),
        .minute_ones (minute_ones),
        .second_tens (second_tens),
        .second_ones (second_ones)
    );


    bcdto7segment_display realitystone(
        .pulse_500Hz (pulse_500Hz),
        .sec_digit1 (second_ones),
        .sec_digit2 (second_tens),
        .min_digit1 (minute_ones),
        .min_digit2 (minute_tens),
        .seg (seg),
        .AN (AN)
    );


endmodule