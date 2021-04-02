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
    output enable_timer_cooktime, 
    output [3:0] second_ones,
    output [3:0] second_tens, 
    output [3:0] minute_ones,
    output [3:0] minute_tens,
    output debounce_min,
    output debounce_sec
    );  

    wire debounce_minutes, debounce_seconds;

    debounce soulstone (
        .pulse_1Hz (clk),
        .minutes_seconds_up (minutes_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_minutes)
    );

    debounce realitystone (
        .pulse_1Hz (clk),
        .minutes_seconds_up (seconds_up),
        .reset (reset),
        .minutes_seconds_debounce (debounce_seconds)
    );
    
    assign debounce_min = debounce_minutes;
    assign debounce_sec = debounce_seconds;
    
    egg_timer_fsm mindstone (
        .pulse_1Hz (clk),
        .cook_time (cook_time),
        .minutes_debounce_up (debounce_minutes),
        .seconds_debounce_up (debounce_seconds),
        .start (start),
        .reset (reset),
        .enable_timer_cooktime (enable_timer_cooktime),
        .load_second_ones (second_ones),
        .load_second_tens (second_tens), 
        .load_minute_ones (minute_ones),
        .load_minute_tens (minute_tens)
    ); 


endmodule