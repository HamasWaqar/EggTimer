`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2021 03:53:01 PM
// Design Name: 
// Module Name: top_testbench
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


module top_tb(

    );
    
        reg clk;
        reg cook_time;
        reg minutes_up;
        reg seconds_up;
        reg start;
        reg reset;
        reg enable_egg_timer;
        wire enable_egg_timer_LED;
        wire enable_timer_LED;
        wire timer_load;
        wire timer_counting;
        wire debounce_minutes;
        wire debounce_seconds;
        wire load_sec_ones;
        wire load_sec_tens;
        wire load_min_ones;
        wire load_min_tens;
        wire [3:0] second_ones;
        wire [3:0] second_tens;
        wire [3:0] minute_ones;
        wire [3:0] minute_tens;
  

        top dut(
            .clk(clk),
            .cook_time (cook_time),
            .start (start),
            .minutes_up (minutes_up),
            .seconds_up (seconds_up),
            .reset (reset),
            .enable_egg_timer (enable_egg_timer),
            .enable_egg_timer_LED (enable_egg_timer_LED),
            .enable_timer_LED (enable_timer_LED),
            .timer_load (timer_load),
            .timer_counting (timer_counting),
            .debounce_minutes (debounce_minutes),
            .debounce_seconds (debounce_seconds),
            .load_sec_ones (load_sec_ones),
            .load_sec_tens (load_sec_tens),
            .load_min_ones (load_min_ones),
            .load_min_tens (load_min_tens),
            .second_ones (second_ones),
            .second_tens (second_tens),
            .minute_ones (minute_ones),
            .minute_tens (minute_tens)
        );
        
        initial begin
            clk = 0;
            reset = 0;
            cook_time = 0;
            start = 0;
            minutes_up = 0;
            seconds_up = 0;
            enable_egg_timer = 0;
            #10;
            enable_egg_timer = 1;
            #10;
            reset = 1;
            #10;
            reset = 0;
            #10;
            cook_time = 1;
            minutes_up = 1;
            #130;
            seconds_up = 1;
            #10;
            minutes_up = 0;
            #130;
            seconds_up = 0;
            #10;
            cook_time = 0;
            #20;
            start = 1;
            #400;
            $finish; 
        end
        
        always begin
            #5; clk = ~clk;
        end
endmodule