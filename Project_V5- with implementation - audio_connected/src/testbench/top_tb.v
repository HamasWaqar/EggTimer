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
        reg reset;
        reg start;
        reg minutes_up;
        reg seconds_up;
        reg enable_timer;
        wire enable_timer_countdown;
        wire enable_load;
        wire [3:0] load_second_ones;
        wire [3:0] load_second_tens;
        wire [3:0] load_minute_ones;
        wire [3:0] load_minute_tens;
        wire debounce_min;
        wire debounce_sec;
        wire [3:0] second_ones;
        wire [3:0] second_tens;
        wire [3:0] minute_ones;
        wire [3:0] minute_tens;
        

        top dut(
            .clk(clk),
            .reset (reset),
            .start (start),
            .cook_time (cook_time),
            .minutes_up (minutes_up),
            .seconds_up (seconds_up),
            .enable_timer (enable_timer),
            .enable_timer_countdown (enable_timer_countdown),
            .enable_load (enable_load),
            .load_second_ones (load_second_ones),
            .load_second_tens (load_second_tens),
            .load_minute_ones (load_minute_ones),
            .load_minute_tens (load_minute_tens),
            .debounce_min (debounce_min),
            .debounce_sec (debounce_sec),
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
            enable_timer = 0;
            #10;
            reset = 1;
            #10;
            reset = 0;
            enable_timer = 1;
            #10;
            cook_time = 1;
            minutes_up = 1;
            #50;
            seconds_up = 1;
            #10;
            minutes_up = 0;
            #50;
            seconds_up = 0;
            #10;
            cook_time = 0;
            #20;
            start = 1;
            #100;
            reset = 1;
            #20;
            $finish;
        end
        
        always begin
            #5 clk = ~clk;
        end
endmodule