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


module bcdto7segment_display(
    input pulse_500Hz,
    input [3:0] sec_digit1,
    input [3:0] sec_digit2,
    input [3:0] min_digit1,
    input [3:0] min_digit2,
    output [6:0] seg,
    output reg [7:0] AN
    );
    
    reg [3:0] digit;
    bcdto7segment_dataflow ironman (.v(digit), .seg(seg));
    
    parameter [7:0] sec1 = 8'b11111110;
    parameter [7:0] sec2 = 8'b11111101;
    parameter [7:0] min1 = 8'b11111011;
    parameter [7:0] min2 = 8'b11110111;
    

    reg [1:0] counter;
    always @(posedge pulse_500Hz) begin
        if (counter  >= 3) begin
            counter <= 0;
        end else 
            counter <= counter + 1;
            
        case (counter)
            0: begin
                digit <= sec_digit1;
                AN = sec1;
            end
            1: begin
                digit <= sec_digit2;
                AN = sec2;
            end
            2: begin
                digit <= min_digit1;
                AN = min1;
            end
            3: begin
                digit <= min_digit2;
                AN = min2;
            end
            default: begin
                digit <= sec_digit1;
                AN = sec1;
            end
        endcase
   end

    
endmodule