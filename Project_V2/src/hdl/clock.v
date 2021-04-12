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


module clock (
    input CLK100Mhz,
    input reset,
    output reg pulse_500Hz,
    output reg pulse_1Hz
    );
    
    wire clk_5MHz;
    reg [25:0] divider_count_500Hz = 10000;
    reg [25:0] divider_count_1Hz = 5000000;
    
      
       clk_wiz_0 dormammu
        (
         // Clock out ports
         .clk_out1(clk_5MHz),     // output clk_out1
         // Status and control signals
         .locked(locked),       // output locked
        // Clock in ports
         .clk_in1(CLK100Mhz));      // input clk_in1

        
       always @(posedge clk_5MHz) begin
               if (reset)
                pulse_500Hz = 0;
               else if (divider_count_500Hz == 0) begin
                   divider_count_500Hz <= 5000;
                   pulse_500Hz = ~pulse_500Hz;
               end
               else divider_count_500Hz <= divider_count_500Hz - 1;    
       end
       
       
       always @(posedge clk_5MHz) begin
              if (reset)
                pulse_1Hz = 0;
              else if (divider_count_1Hz == 0) begin
                  divider_count_1Hz <= 2500000;
                  pulse_1Hz = ~pulse_1Hz;
              end
              else divider_count_1Hz <= divider_count_1Hz - 1;   
      end
      

endmodule