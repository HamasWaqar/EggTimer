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
    input clk,
    input cook_time,
    input minutes_up,
    input seconds_up,
    input start,
    input reset,
    input enable_egg_timer, 
    output enable_egg_timer_LED, 
    output enable_timer_LED,
    output timer_load,
    output timer_counting,
    output debounce_minutes,
    output debounce_seconds,
    output load_sec_ones,
    output load_sec_tens,
    output load_min_ones,
    output load_min_tens,
    output minute_tens,
    output minute_ones,
    output second_tens,
    output second_ones
    );  

    //wire [3:0] load_sec_ones, load_sec_ones, load_min_ones, load_min_tens;
    //wire [3:0] minute_tens, minute_ones, second_tens, second_ones;

    //wire debounce_minutes, debounce_seconds;

    debounce soulstone (
        .pulse_1Hz (clk),
        .minutes_seconds_up (minutes_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_minutes)
    );

    debounce powerstone (
        .pulse_1Hz (clk),
        .minutes_seconds_up (seconds_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_seconds)
    );
    
    egg_timer_fsm mindstone (
        .pulse_1Hz (clk),
        .cook_time (cook_time),
        .minutes_debounce_up (debounce_minutes),
        .seconds_debounce_up (debounce_seconds),
        .start (start),
        .reset (reset),
        .timer_enable (enable_egg_timer),
        .timer_load (timer_load),
        .timer_counting(timer_counting),
        .load_second_ones (load_sec_ones),
        .load_second_tens (load_sec_tens), 
        .load_minute_ones (load_min_ones),
        .load_minute_tens (load_min_tens)
    );

   

    timer spacestone (
        .pulse_1Hz (clk),
        .reset (reset),
        .enable (timer_counting),
        .load_min_ones (load_min_ones),
        .load_sec_tens (load_sec_tens),
        .load_sec_ones (load_sec_ones),
        .load_min_tens (load_min_tens),
        .load (timer_load),
        .minute_tens (minute_tens),
        .minute_ones (minute_ones),
        .second_tens (second_tens),
        .second_ones (second_ones)
    );



endmodule