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
    input [3:0] load_sec_ones,
    input [3:0] load_sec_tens,
    input [3:0] load_min_ones,
    input [3:0] load_min_tens,
    input load,
    input reset,
    input enable, 
    output [3:0] second_ones,
    output [3:0] second_tens, 
    output [3:0] minute_ones,
    output [3:0] minute_tens
    );  

    timer spacestone (
        .pulse_1Hz (clk),
        .reset (reset),
        .enable (enable),
        .load_min_ones (load_min_ones),
        .load_sec_tens (load_sec_tens),
        .load_sec_ones (load_sec_ones),
        .load_min_tens (load_min_tens),
        .load (load),
        .minute_tens (minute_tens),
        .minute_ones (minute_ones),
        .second_tens (second_tens),
        .second_ones (second_ones)
    );


endmodule