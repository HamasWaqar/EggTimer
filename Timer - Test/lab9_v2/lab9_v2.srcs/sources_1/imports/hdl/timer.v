`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Design Name: Egg Timer
// Module Name: downcounter
// Project Name: 
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Moore FSM to create a downcounter
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
    output reg [3:0] second_ones,
    output reg [3:0] second_tens,
    output reg [3:0] minute_ones,
    output reg [3:0] minute_tens
    );
    

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

    wire enable_second_ten, enable_minute_one, enable_minute_ten, endtime;

    assign endtime = ((second_ones == 0) && (second_tens == 0) && (minute_ones == 0) && (minute_tens == 0)) ? 1'b1 : 1'b0;
    assign enable_second_one = (~endtime && enable) ? 1'b1 : 1'b0;
    assign enable_second_ten = ((second_ones == 0) && ~endtime && enable) ? 1'b1 : 1'b0;
    assign enable_minute_one = ((second_ones == 0) && (second_tens == 0) && ~endtime && enable) ? 1'b1 : 1'b0;
    assign enable_minute_ten = ((second_ones == 0) && (second_tens == 0) && (minute_ones == 0) && ~endtime && enable) ? 1'b1 : 1'b0;
    
    always @ (posedge pulse_1Hz or posedge enable_second_one or posedge enable_second_ten or posedge enable_minute_one or posedge reset or posedge load) begin
        if (reset) begin
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
            if (enable_second_one) begin
                second_ones <= downcount (.current_number(second_ones), .ten_digit(1'b0));
                if (enable_second_ten) begin 
                   second_tens <=  downcount (.current_number(second_tens), .ten_digit(1'b1));
                   if (enable_minute_one) begin
                     minute_ones <= downcount (.current_number(minute_ones), .ten_digit(1'b0));
                     if (enable_minute_ten) begin
                      minute_tens <= downcount (.current_number(minute_tens), .ten_digit(1'b1));
                    end
                   end
                end
              end
          end
        end
    end



endmodule