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


module egg_timer_fsm (
    input pulse_1Hz,
    input cook_time,
    input minutes_debounce_up,
    input seconds_debounce_up,
    input start,
    input reset,
    output reg enable_timer_cooktime,
    output reg[3:0] load_second_ones,
    output reg[3:0] load_second_tens, 
    output reg [3:0] load_minute_ones,
    output reg [3:0] load_minute_tens
    );  

    reg [1:0] state, nextstate;
    parameter set_time = 0, timer_state = 1, start_time = 2;

    always @ (state or cook_time or start) begin
       case (state)
            set_time: begin
                if (start)
                    nextstate = start_time;
                else
                    nextstate = set_time;
            end
            start_time: begin
                nextstate = timer_state;
            end
            timer_state: begin
                if (cook_time)
                    nextstate = set_time;
                else
                    nextstate = timer_state;
            end
       endcase
    end

    always @(posedge pulse_1Hz, posedge reset) begin
        if (reset)
            state = timer_state;
        else
            state = nextstate;
    end


    function [3:0] upcount;
        input [3:0] current_number;
        input ten_digit;
        begin
            if (ten_digit && (current_number == 4'd5))
                upcount = 4'd0;
            else if (~ten_digit && (current_number == 4'd9))
                upcount = 4'd0;
            else
               upcount = current_number + 4'b1; 
        end
    endfunction


    
    assign enable_minutes_load_ten = (load_minute_ones == 9) ? 1 : 0;
    assign enable_seconds_load_ten = (load_second_ones == 9) ? 1 : 0;
    
    always @ (posedge pulse_1Hz or posedge reset) begin
        if (reset) begin
            load_second_ones <= 0;
            load_second_tens <= 0;
            load_minute_ones <= 0;
            load_minute_tens <= 0;
        end else begin
            if ((state == set_time) && minutes_debounce_up) begin 
                load_minute_ones <= upcount (.current_number(load_minute_ones), .ten_digit(1'b0));
                if (enable_minutes_load_ten) begin
                    load_minute_tens <= upcount (.current_number(load_minute_tens), .ten_digit(1'b1));
                end
            end
            if ((state == set_time) && seconds_debounce_up) begin
                load_second_ones <= upcount (.current_number(load_second_ones), .ten_digit(1'b0));
                if (enable_seconds_load_ten) begin
                    load_second_tens <= upcount (.current_number(load_second_tens), .ten_digit(1'b1));
                end
            end
        end
    end
    
    always @ ( posedge pulse_1Hz or posedge reset) begin
        if (reset)
            enable_timer_cooktime <= 0;
        else if (state == set_time)
           enable_timer_cooktime <= 1; 
        else
            enable_timer_cooktime <= 0;
    end
endmodule