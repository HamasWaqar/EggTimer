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
    input sec_digit1,
    input sec_digit2,
    input min_digit1,
    input min_digit2,
    output [6:0] seg,
    output [7:0] AN
    );
    
    reg [3:0] digit;
    bcdto7segment_dataflow(.v(digit), .seg(seg));
    
    parameter [7:0] sec1 = 8'b11111110;
    parameter [7:0] sec2 = 8'b11111101;
    parameter [7:0] min1 = 8'b11111011;
    parameter [7:0] min2 = 8'b11110111;
    
    reg [7:0] next_state;
    reg [7:0] state = sec1;
    

    always @(state, min_digit1, min_digit2, sec_digit2, sec_digit1) begin
        case (state)
            sec1: begin
                next_state <= sec2;
                digit <= sec_digit1;
            end
            sec2: begin
                next_state <= min1;
                digit <= sec_digit2;
            end
            min1: begin
                next_state <= min2;
                digit <= min_digit1;
            end
            min2: begin
                next_state <= sec1;
                digit <= min_digit2;
            end
            default: next_state <= sec1;
        endcase
   end

    always @ (posedge pulse_500Hz) begin
        state <= next_state;
    end
    
    assign AN = state;
    
endmodule