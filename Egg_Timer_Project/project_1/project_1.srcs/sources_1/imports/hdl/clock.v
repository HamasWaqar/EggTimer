`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Carleton University 
// Engineer: Hamas Waqar
// 
// Create Date: 03/28/2021 03:34:24 PM
// Module Name: clock
// Project Name: E
// Target Devices: NEXYS A7 100 T
// Tool Versions: 
// Description: Clock Divider - Output two syncronous clocks at 500 Hz, and 1 Hz from the BCD Display and the 
// Dependencies: 
// 
// Revision: 04/16/2021
// Revision 1.5
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////


module clock (
    input CLK100Mhz,
    input reset,
    output reg pulse_500Hz,
    output reg pulse_1Hz
    );
    
    /*
        The eggtimer will be running at two clock frequencies; at 1 Hz and 500 Hz. 
        The 1 Hz clock will be controlling the timer aspect of the egg timer, as it will be counting down the time every 1 second
        The 500 Hz clock will be controlling the four seven segment displays by alternating the seven segment displays making it seem
        that the four seven segment display is on to the human eye. 
    */
    
    wire clk_5MHz;
    reg [25:0] divider_count_500Hz = 10000;
    reg [25:0] divider_count_1Hz = 5000000;
    
      
      //Generating a minimum clock frequency of 5 MHz that the Nexys A7 FPGA can produce using and vivado clk IP
       clk_wiz_0 dormammu
        (
         // Clock out ports
         .clk_out1(clk_5MHz),     // output clk_out1
         // Status and control signals
         .locked(locked),       // output locked
        // Clock in ports
         .clk_in1(CLK100Mhz));      // input clk_in1

       
       /* 
       Using a clock divider to generate a 500 Hz clock
       
       Calculation: increment number = fin/(fout * 2) = 5 MHz / (500 Hz * 2) = 5000
       Note the input clock from the FPGA is 5 MHz
       */
       always @(posedge clk_5MHz) begin
               if (reset)
                pulse_500Hz = 0;
               else if (divider_count_500Hz == 0) begin
                   divider_count_500Hz <= 5000;
                   pulse_500Hz = ~pulse_500Hz;
               end
               else divider_count_500Hz <= divider_count_500Hz - 1;    
       end
       
      /* 
      Using a clock divider to generate a 1 Hz clock
      
      Calculation: increment number = fin/(fout * 2) = 5 MHz / (1 Hz * 2) = 2500000
      Note the input clock from the FPGA is 5 MHz
      */
      
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