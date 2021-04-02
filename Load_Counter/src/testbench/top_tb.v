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
        wire enable_timer_cooktime;
        wire [3:0] second_ones;
        wire [3:0] second_tens;
        wire [3:0] minute_ones;
        wire [3:0] minute_tens;
        wire debounce_min;
        wire debounce_sec;
        

        top dut(
            .clk(clk),
            .reset (reset),
            .start (start),
            .cook_time (cook_time),
            .minutes_up (minutes_up),
            .seconds_up (seconds_up),
            .enable_timer_cooktime (enable_timer_cooktime),
            .second_ones (second_ones),
            .second_tens (second_tens),
            .minute_ones (minute_ones),
            .minute_tens (minute_tens),
            .debounce_min (debounce_min),
            .debounce_sec (debounce_sec)
        );
        
        initial begin
            clk = 0;
            reset = 0;
            cook_time = 0;
            start = 0;
            minutes_up = 0;
            seconds_up = 0;
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
            #50;
            reset = 1;
            #20;
            $finish;
        end
        
        always begin
            #5 clk = ~clk;
        end
endmodule