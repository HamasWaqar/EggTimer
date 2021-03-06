`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: Timer
// Project Name: Egg Timer
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Loads the start time to the timer or count count the the time depending on the operaitng state of the egg timer
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module timer(
    input pulse_1Hz,
    input reset,
    input [3:0] load_min_tens,
    input [3:0] load_min_ones,
    input [3:0] load_sec_ones,
    input [3:0] load_sec_tens,
    input load,
    input enable,
    input enable_timer,
    output endtime,
    output reg [3:0] second_ones,
    output reg [3:0] second_tens,
    output reg [3:0] minute_ones,
    output reg [3:0] minute_tens
    );
    
    /*
        if the egg timer is in the set_time state as indicated by load input being high, then a time can be loaded into the egg timer
        if the egg timer is the timer_state, as indicated by the enable timer input, then the timer is enable to count down
    */
    
    /*
        Downcounter to downcount the times - using a function
    */  
    function [3:0] downcount;
        input [3:0] current_number;
        input ten_digit;
        begin
            if (ten_digit && (current_number == 4'd0))
                downcount = 4'd5;
            else if (~ten_digit && (current_number == 4'd0))
                downcount = 4'd9;
            else
               downcount = current_number - 4'b1; 
        end
    endfunction

    wire enable_second_ten, enable_minute_one, enable_minute_ten;
    
    assign endtime = ((second_ones == 0) && (second_tens == 0) && (minute_ones == 0) && (minute_tens == 0)) ? 1 : 0;
    /*
       Timer block: loads and counts down the time for the timer
    */
    always @ (posedge pulse_1Hz or posedge reset) begin
        if (reset || ~enable_timer) begin
          second_ones <= 0;
          second_tens <= 0;
          minute_ones <= 0;
          minute_tens <= 0;
        end else begin
          if (load) begin
            second_ones <= load_sec_ones;
            second_tens <= load_sec_tens;
            minute_ones <= load_min_ones;
            minute_tens <= load_min_tens;
          end else begin
            if (enable) begin
                if (!((second_ones == 0) && (second_tens == 0) && (minute_ones == 0) && (minute_tens == 0))) begin
                    second_ones <= downcount (.current_number(second_ones), .ten_digit(1'b0));
                    if (second_ones == 0) begin 
                       second_tens <=  downcount (.current_number(second_tens), .ten_digit(1'b1));
                       if (second_tens == 0) begin
                         minute_ones <= downcount (.current_number(minute_ones), .ten_digit(1'b0));
                         if (minute_ones == 0) begin
                          minute_tens <= downcount (.current_number(minute_tens), .ten_digit(1'b1));
                        end
                       end
                    end
                  end
              end
          end
        end
    end

endmodule