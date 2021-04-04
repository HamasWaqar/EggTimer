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
    input enable_timer,
    output enable_timer_countdown, 
    output enable_load,
    output [3:0] load_second_ones,
    output [3:0] load_second_tens, 
    output [3:0] load_minute_ones,
    output [3:0] load_minute_tens,
    output debounce_min,
    output debounce_sec,
    output [3:0] second_ones,
    output [3:0] second_tens, 
    output [3:0] minute_ones,
    output [3:0] minute_tens
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
        .enable_timer (enable_timer),
        .enable_load (enable_load),
        .enable_timer_countdown (enable_timer_countdown),
        .load_second_ones (load_second_ones),
        .load_second_tens (load_second_tens), 
        .load_minute_ones (load_minute_ones),
        .load_minute_tens (load_minute_tens)
    ); 
    
    timer spacestone(
        .pulse_1Hz (clk),
        .reset (reset),
        .load_min_tens (load_minute_tens),
        .load_min_ones (load_minute_ones),
        .load_sec_ones (load_second_ones),
        .load_sec_tens (load_second_tens),
        .load (enable_load),
        .enable (enable_timer_countdown),
        .second_ones (second_ones),
        .second_tens (second_tens),
        .minute_ones (minute_ones),
        .minute_tens (minute_tens)
        );


endmodule