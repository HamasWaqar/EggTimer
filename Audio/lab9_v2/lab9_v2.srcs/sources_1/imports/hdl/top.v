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
    input CLK100MHZ,
    input reset,
    input enable,
    output reg AUD_PWM,
    output AUD_SD
    );  
    
    parameter clk_counter_milisec = 2500;
    
    wire clk_5MHz;
    reg clk_2dot5MHz = 0;
    reg clk_100Hz = 0;
    reg [15:0] counter;
    reg clk_1ms = 0;
    
    
      clk_wiz_0 demo_clk(
      // Clock out ports
      .clk_out1(clk_5MHz),     // output clk_out1
     // Clock in ports
      .clk_in1(CLK100MHZ));      // input clk_in1
      
    reg [27:0] tone;
      always @(posedge clk_5MHz) tone <= tone+1;
      
      wire [6:0] fastsweep = (tone[22] ? tone[21:15] : ~tone[21:15]);
      wire [6:0] slowsweep = (tone[25] ? tone[24:18] : ~tone[24:18]);
      wire [14:0] clkdivider = {2'b01, (tone[27] ? slowsweep : fastsweep), 6'b000000};
      
      
      always @(posedge clk_5MHz) if(counter==0) counter <= clkdivider; else counter <= counter-1;
      
     
      always @(posedge clk_5MHz) if(counter==0) AUD_PWM <= ~AUD_PWM;
      
      
    
    //assign AUD_PWM = 0;
    assign AUD_SD = 1'b1;
endmodule